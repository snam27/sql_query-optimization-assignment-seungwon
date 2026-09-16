/*
============================================================
[4장 1강] 실습문제: 윈도우 함수 구조와 집계 함수 비교
============================================================

[실습 목표]
- GROUP BY 집계 함수와 윈도우 함수의 결과 구조 차이를 설명할 수 있다.
- PARTITION BY를 이용해 그룹별 계산을 수행할 수 있다.
- ORDER BY와 프레임을 이용해 윈도우 계산 범위를 이해할 수 있다.
- 실행계획에서 WindowAgg와 Sort 노드를 확인할 수 있다.

[사용 환경]
- PostgreSQL
- DBeaver

[사용 데이터]
이번 과정에서는 아래 12개 CSV로 구성된 동일한 Retail Data Warehouse 데이터셋을 계속 사용합니다.

- customers
- employees
- order_items
- orders
- payments
- products
- promotions
- returns
- shipments
- stores
- suppliers
- categories

[이번 강에서 주로 사용하는 테이블]
- employees
- orders
- order_items

[주요 컬럼]
employees
- employee_id
- store_id
- salary

orders
- order_id
- customer_id
- store_id
- order_date

order_items
- order_item_id
- order_id
- product_id
- qty
- price
*/


/*
============================================================
필수 1. GROUP BY와 윈도우 함수 결과 비교하기
============================================================

[문제 1-1] 매장별 평균 급여를 두 방식으로 계산하기

[문제 설명]
인사팀에서 매장별 평균 급여를 확인하려고 합니다.

먼저 GROUP BY를 이용해 매장별 평균 급여만 조회하고,
다음에는 윈도우 함수를 이용해 직원별 급여 행을 유지하면서
같은 매장의 평균 급여를 함께 표시하세요.

[요구사항]
1. employees 테이블에서 store_id별 평균 salary를 계산하세요.
2. GROUP BY를 사용하고 평균 급여 컬럼명은 store_avg_salary로 지정하세요.
3. 같은 계산을 AVG(salary) OVER (PARTITION BY store_id) 형태의 윈도우 함수로 다시 작성하세요.
4. 윈도우 함수 결과에서는 다음 컬럼을 조회하세요.
   - employee_id
   - store_id
   - salary
   - store_avg_salary
5. 두 쿼리의 결과 행 수를 각각 확인하세요.
6. 다음 질문에 답하세요.
   Q1. GROUP BY 결과에서 개별 employee_id가 사라지는 이유는 무엇인가요?
   Q2. 윈도우 함수는 평균을 계산하면서도 직원별 행을 유지할 수 있는 이유는 무엇인가요?
   Q3. "매장별 평균만 필요한 경우"와 "직원별 급여와 매장 평균을 함께 봐야 하는 경우"에는 각각 어떤 방식을 사용하는 것이 적절한가요?

[작성 결과]
- GROUP BY SQL
- 윈도우 함수 SQL
- 두 결과 행 수 비교
- Q1~Q3 답변
*/

-- [코드 작성란]




/*
============================================================
필수 2. PARTITION BY, ORDER BY, 프레임 구조 확인하기
============================================================

[문제 2-1] 매장별 급여 순서에 따른 누적 평균 계산하기

[문제 설명]
각 매장에서 급여가 낮은 직원부터 높은 직원 순서로 정렬한 뒤,
현재 직원까지의 누적 평균 급여를 계산하려고 합니다.

윈도우 함수의 PARTITION BY, ORDER BY, 프레임을 모두 사용하여
각 요소가 어떤 역할을 하는지 확인하세요.

[요구사항]
1. employees 테이블을 사용하세요.
2. store_id별로 파티션을 나누세요.
3. 각 파티션 안에서 salary 오름차순, employee_id 오름차순으로 정렬하세요.
4. AVG(salary) 윈도우 함수를 사용하세요.
5. 프레임은 다음과 같이 지정하세요.

   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

6. 결과 컬럼은 다음과 같이 조회하세요.
   - employee_id
   - store_id
   - salary
   - running_avg_salary
7. 같은 쿼리에 EXPLAIN을 적용하고 WindowAgg와 Sort 노드가 있는지 확인하세요.
8. 다음 질문에 답하세요.
   Q1. PARTITION BY store_id는 어떤 역할을 하나요?
   Q2. 윈도우 함수 안의 ORDER BY는 어떤 역할을 하나요?
   Q3. ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW는 어떤 범위를 계산하나요?
   Q4. 실행계획의 WindowAgg와 Sort는 각각 어떤 작업을 의미하나요?

[작성 결과]
- 누적 평균 SQL
- EXPLAIN SQL
- 실행계획 확인
- Q1~Q4 답변
*/

-- [코드 작성란]




/*
============================================================
과제. 주문 상세 행을 유지하면서 고객별 구매금액 계산하기
============================================================

[문제 3-1] 고객별 총 구매금액을 윈도우 함수로 표시하기

[문제 설명]
고객별 총 구매금액을 계산하되,
각 주문 상품 행도 그대로 유지해야 합니다.

GROUP BY로 고객별 합계를 만들면 주문별·상품별 상세 행이 사라집니다.
이번에는 윈도우 함수를 이용해 상세 행을 유지하면서
고객별 총 구매금액을 같은 결과에서 확인하세요.

※ 과제는 필수 문제와 동일한 수준입니다.

[요구사항]
1. orders와 order_items를 order_id 기준으로 JOIN하세요.
2. 주문상품별 구매금액은 qty * price로 계산하세요.
3. 다음 컬럼을 조회하세요.
   - orders.order_id
   - orders.customer_id
   - order_items.product_id
   - order_items.qty
   - order_items.price
   - item_amount
4. SUM(qty * price) OVER (PARTITION BY customer_id)를 사용하여
   customer_total_amount를 계산하세요.
5. 결과를 customer_id, order_id, product_id 순으로 정렬하세요.

6. 다음 질문에 답하세요.
   Q1. customer_total_amount가 같은 고객의 여러 행에서 반복되는 이유는 무엇인가요?
   - PARTITION BY customer_id가 GROUP BY처럼 행을 압축하지 않고, 
     각 원본 행에 해당 고객 그룹의 집계값을 복사해서 붙여주기 때문이다.
   
   Q2. GROUP BY로 같은 고객별 합계를 계산했다면 어떤 상세 정보가 사라지나요?
   - order_id, product_id, qty, price, item_amount 같은 주문 및 상품 단위의 상세 행 정보가 사라지고 
   	 customer_id별 합계만 남는다.
   
   Q3. 개별 주문상품과 고객별 총 구매금액을 동시에 봐야 하는 분석에서 윈도우 함수가 적합한 이유는 무엇인가요?
   - GROUP BY 없이도 상세 행(주문상품 단위)을 그대로 유지하면서 
     동시에 그룹 집계값을 같은 결과내에서 함께 보여줄 수 있기 때문이다.
   
   Q4. 윈도우 함수에서 PARTITION BY, ORDER BY, 프레임은 각각 어떤 역할을 하나요?
   - PARTITION BY는 집계를 계산할 그룹을 나누는 역할을 한다.
   - ORDER BY는 그룹 내에서 행의 순서를 정하는 역할을 한다. 
   - 프레임은 ORDER BY로 정해진 순서 중 실제로 계산에 포함할 행의 범위를 지정하는 역할을 한다.
   
   
[제출 결과]
- 전체 SQL
- 결과 확인
- Q1~Q4 답변
*/

-- [코드 작성란]
SELECT
    o.order_id,
    o.customer_id,
    oi.product_id,
    oi.qty,
    oi.price,
    oi.qty * oi.price AS item_amount,
    SUM(oi.qty * oi.price) OVER (PARTITION BY o.customer_id) AS customer_total_amount
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
ORDER BY o.customer_id, o.order_id, oi.product_id;



/*
============================================================
실습 마무리
============================================================

아래 내용을 한 문단으로 정리하세요.

1. GROUP BY와 윈도우 함수의 가장 큰 차이는 무엇인가요?
2. PARTITION BY, ORDER BY, 프레임은 각각 어떤 역할을 하나요?
3. 윈도우 함수 실행계획에서 WindowAgg와 Sort를 확인하는 이유는 무엇인가요?
*/
