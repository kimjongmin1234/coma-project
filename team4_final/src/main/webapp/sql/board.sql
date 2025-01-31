CREATE TABLE BOARD (
    BOARD_NUM INT PRIMARY KEY,      -- 게시글의 고유 식별자 (기본키)
    BOARD_TITLE VARCHAR(100) NOT NULL,    -- 게시글 제목
    BOARD_CONTENT VARCHAR(1000),          -- 게시글 내용 (NULL 허용)
    BOARD_CNT INT DEFAULT 0,           -- 조회수 (기본값 0)
    BOARD_LOCATION VARCHAR(100), -- 게시글 지역
    BOARD_WRITER_ID VARCHAR(100),   -- 글 작성자의 FK (외래키)
    -- 외래키 제약조건 설정
    CONSTRAINT FK_BOARD_WRITER_ID 
    FOREIGN KEY (BOARD_WRITER_ID)
    REFERENCES MEMBER(MEMBER_ID)
    ON DELETE CASCADE
);

-- 샘플 데이터 삽입
INSERT INTO BOARD (BOARD_NUM,BOARD_TITLE,BOARD_CONTENT,BOARD_LOCATION,BOARD_WRITER_ID)
VALUES ((SELECT NVL(MAX(BOARD_NUM),0)+1 FROM BOARD), 'board_title1', 'board_content1', 'board_location1', '샘플유저1');
INSERT INTO BOARD (BOARD_NUM,BOARD_TITLE,BOARD_CONTENT,BOARD_LOCATION,BOARD_WRITER_ID)
VALUES ((SELECT NVL(MAX(BOARD_NUM),0)+1 FROM BOARD), 'board_title2', 'board_content2', 'board_location2', '샘플유저2');
INSERT INTO BOARD (BOARD_NUM,BOARD_TITLE,BOARD_CONTENT,BOARD_LOCATION,BOARD_WRITER_ID)
VALUES ((SELECT NVL(MAX(BOARD_NUM),0)+1 FROM BOARD), 'board_title3', 'board_content3', 'board_location3', '샘플유저3');
INSERT INTO BOARD (BOARD_NUM,BOARD_TITLE,BOARD_CONTENT,BOARD_LOCATION,BOARD_WRITER_ID)
VALUES ((SELECT NVL(MAX(BOARD_NUM),0)+1 FROM BOARD), 'board_title4', 'board_content4', 'board_location4', '샘플유저4');
INSERT INTO BOARD (BOARD_NUM,BOARD_TITLE,BOARD_CONTENT,BOARD_LOCATION,BOARD_WRITER_ID)
VALUES ((SELECT NVL(MAX(BOARD_NUM),0)+1 FROM BOARD), 'board_title5', 'board_content5', 'board_location5', '샘플유저5');
INSERT INTO BOARD (BOARD_NUM,BOARD_TITLE,BOARD_CONTENT,BOARD_LOCATION,BOARD_WRITER_ID)
VALUES ((SELECT NVL(MAX(BOARD_NUM),0)+1 FROM BOARD), 'boar''d_title6', 'board_content6', 'board_location6', '샘플유저6');

SELECT COUNT(*) AS BOARD_TOTAL FROM BOARD WHERE BOARD_LOCATION LIKE '%'||?||'%' AND BOARD_TITLE LIKE '%'||?||'%'

--페이지네이션 BETWEEN, ORDER BY DESC, ROWNUM, 서브쿼리,
SELECT
	ROWNUM,
	BOARD_NUM,
    BOARD_TITLE,
    BOARD_CONTENT,
    BOARD_CNT,
    BOARD_LOCATION,
    BOARD_WRITER_ID
FROM (
    SELECT 
        BOARD_NUM, 
        BOARD_TITLE, 
        BOARD_CONTENT, 
        BOARD_CNT, 
        BOARD_LOCATION, 
        BOARD_WRITER_ID
    FROM 
        BOARD B
    ORDER BY 
        B.BOARD_NUM DESC
) ROWNUM
WHERE ROWNUM BETWEEN 1 AND 10;

--페이지네이션 (ALLPAGENATION)
SELECT
	RN,
	BOARD_NUM,
    BOARD_TITLE,
    BOARD_CONTENT,
    BOARD_CNT,
    BOARD_LOCATION,
    BOARD_WRITER_ID
FROM (
    SELECT 
        BOARD_NUM, 
        BOARD_TITLE, 
        BOARD_CONTENT, 
        BOARD_CNT, 
        BOARD_LOCATION, 
        BOARD_WRITER_ID,
        ROW_NUMBER() OVER (ORDER BY BOARD_NUM DESC) AS RN
    FROM 
        BOARD
)
WHERE RN BETWEEN 1 AND 10;
-- ROW_NUMBER() : 파티션 내 각 행에 순차적인 정수를 할당 (윈도우함수)
-- OVER : 윈도우 함수의 조건절

-- 기본문법
-- ROW_NUMBER() OVER(PARTITION BY [그룹핑할 컬럼] ORDER BY [정렬할 컬럼]) 
-- PARTITION BY 선택, ORDER BY 필수

--ID로 검색 (ALLSEARCH_ID)
SELECT
	BOARD_PAGENATION.RN,
	BOARD_PAGENATION.BOARD_NUM,
    BOARD_PAGENATION.BOARD_TITLE,
    BOARD_PAGENATION.BOARD_CONTENT,
    BOARD_PAGENATION.BOARD_CNT,
    BOARD_PAGENATION.BOARD_LOCATION,
    BOARD_PAGENATION.BOARD_WRITER_ID
FROM (
    SELECT 
        BOARD_NUM, 
        BOARD_TITLE, 
        BOARD_CONTENT, 
        BOARD_CNT, 
        BOARD_LOCATION, 
        BOARD_WRITER_ID,
        ROW_NUMBER() OVER (ORDER BY BOARD_NUM DESC) AS RN
    FROM 
        BOARD
) BOARD_PAGENATION
JOIN
	MEMBER M
ON
	M.MEMBER_ID = BOARD_PAGENATION.BOARD_WRITER_ID
WHERE  BOARD_PAGENATION.BOARD_WRITER_ID = '샘플유저1' 
AND BOARD_PAGENATION.RN BETWEEN 1 AND 10;
-- JOIN시 별칭 지정

--제목으로 검색 (ALLSEARCH_TITLE)
SELECT
	BOARD_PAGENATION.RN,
	BOARD_PAGENATION.BOARD_NUM,
    BOARD_PAGENATION.BOARD_TITLE,
    BOARD_PAGENATION.BOARD_CONTENT,
    BOARD_PAGENATION.BOARD_CNT,
    BOARD_PAGENATION.BOARD_LOCATION,
    BOARD_PAGENATION.BOARD_WRITER_ID
FROM (
    SELECT 
        BOARD_NUM, 
        BOARD_TITLE, 
        BOARD_CONTENT, 
        BOARD_CNT, 
        BOARD_LOCATION, 
        BOARD_WRITER_ID,
        ROW_NUMBER() OVER (ORDER BY BOARD_NUM DESC) AS RN
    FROM 
        BOARD
) BOARD_PAGENATION
JOIN
	MEMBER M
ON
	M.MEMBER_ID = BOARD_PAGENATION.BOARD_WRITER_ID
WHERE BOARD_PAGENATION.BOARD_LOCATION LIKE '%'||'%' and BOARD_PAGENATION.BOARD_TITLE LIKE '%정소민%'
AND BOARD_PAGENATION.RN BETWEEN 1 AND 10;
--WHERE BOARD_PAGENATION.BOARD_LOCATION LIKE '%'||'%' and BOARD_PAGENATION.BOARD_TITLE LIKE '%'||'%'

--이름으로 검색 (ALLSEARCH_NAME)
SELECT
	BOARD_PAGENATION.RN,
	BOARD_PAGENATION.BOARD_NUM,
    BOARD_PAGENATION.BOARD_TITLE,
    BOARD_PAGENATION.BOARD_CONTENT,
    BOARD_PAGENATION.BOARD_CNT,
    BOARD_PAGENATION.BOARD_LOCATION,
    M.MEMBER_NAME AS BOARD_WRITER_ID
FROM (
    SELECT 
        BOARD_NUM, 
        BOARD_TITLE, 
        BOARD_CONTENT, 
        BOARD_CNT, 
        BOARD_LOCATION, 
        BOARD_WRITER_ID,
        ROW_NUMBER() OVER (ORDER BY BOARD_NUM DESC) AS RN
    FROM 
        BOARD
) BOARD_PAGENATION
JOIN
	MEMBER M
ON
	M.MEMBER_ID = BOARD_PAGENATION.BOARD_WRITER_ID
WHERE  M.MEMBER_NAME LIKE '%'||?||'%' 
AND BOARD_PAGENATION.RN BETWEEN 1 AND 10;
WHERE  M.MEMBER_NAME LIKE '%코마%' 



-- 최신글 6개 검색 SelectAll(ALLROWNUM)
SELECT 
    BOARD_NUM,
    BOARD_TITLE,
    BOARD_CONTENT,
    BOARD_CNT,
    BOARD_LOCATION,
    BOARD_WRITER_ID
FROM (
    SELECT 
        B.BOARD_NUM, 
        B.BOARD_TITLE, 
        B.BOARD_CONTENT, 
        B.BOARD_CNT, 
        B.BOARD_LOCATION, 
        B.BOARD_WRITER_ID
    FROM 
        BOARD B
    JOIN 
        MEMBER M
    ON 
        B.BOARD_WRITER_ID = M.MEMBER_ID
    ORDER BY 
        B.BOARD_NUM DESC
)
WHERE ROWNUM <= 6;  
    
-- 전체글 출력 SelectAll (ALL)
SELECT BOARD_NUM,BOARD_TITLE,BOARD_CONTENT,BOARD_CNT,BOARD_LOCATION,BOARD_WRITER_ID FROM BOARD;

-- PK 검색 SelectONE(__)
SELECT BOARD_NUM,BOARD_TITLE,BOARD_CONTENT,BOARD_CNT,BOARD_LOCATION,BOARD_WRITER_ID FROM BOARD WHERE BOARD_NUM = 1; 

--작성자 검색 SelectAll(SEARCH_ID)
SELECT 
    B.BOARD_NUM,
    B.BOARD_TITLE,
    B.BOARD_CONTENT,
    B.BOARD_CNT,
    B.BOARD_LOCATION,
    B.BOARD_WRITER_ID
FROM 
    BOARD B
JOIN
	MEMBER M
ON
	M.MEMBER_ID = B.BOARD_WRITER_ID
WHERE 
    B.BOARD_WRITER_ID = '샘플유저1';
    
--제목 검색 SelectAll(SEARCH_TITLE)
SELECT 
    B.BOARD_NUM,
    B.BOARD_TITLE,
    B.BOARD_CONTENT,
    B.BOARD_CNT,
    B.BOARD_LOCATION,
    B.BOARD_WRITER_ID
FROM 
    BOARD B
JOIN
	MEMBER M
ON
	M.MEMBER_ID = B.BOARD_WRITER_ID
WHERE 
    B.BOARD_TITLE LIKE '%'||?||'%';
    
--이름 검색 SelectAll(SEARCH_CONTENT)
SELECT 
    B.BOARD_NUM,
    B.BOARD_TITLE,
    B.BOARD_CONTENT,
    B.BOARD_CNT,
    B.BOARD_LOCATION,
    M.MEMBER_NAME AS BOARD_WRITER_ID
FROM 
    BOARD B
JOIN
	MEMBER M
ON
	M.MEMBER_ID = B.BOARD_WRITER_ID
WHERE 
     M.MEMBER_NAME = '%||?||%';
     
SELECT * FROM BOARD;
   
-- 게시글 삭제 Delete
DELETE FROM BOARD WHERE BOARD_NUM = 1;

-- 전체 글의 개수 조회 SelectOne(ONE_COUNT)
SELECT COUNT(*) AS BOARD_TOTAL FROM BOARD;
--ID로 검색한 글 개수 BOARD_WRITER_ID
SELECT COUNT(*) AS BOARD_TOTAL FROM BOARD WHERE BOARD_WRITER_ID = '샘플유저1';
--제목으로 검색한 글 개수 BOARD_TITLE
SELECT COUNT(*) AS BOARD_TOTAL FROM BOARD WHERE BOARD_TITLE LIKE '%플%';
--이름으로 검색한 글 개수 MEMBER_NAME AS BOARD_WRITER_ID
SELECT COUNT(*) AS BOARD_TOTAL FROM BOARD B, MEMBER M WHERE B.BOARD_WRITER_ID = M.MEMBER_ID AND M.MEMBER_NAME LIKE '%플%';


--내용, 제목 수정 BOARD_CONTENT, BOARD_TITLE, BOARD_NUM
UPDATE BOARD SET BOARD_CONTENT = ?, BOARD_TITLE = ? WHERE BOARD_NUM = ?;
UPDATE BOARD SET BOARD_CONTENT = 'board_content2', BOARD_TITLE = 'board_title2' WHERE BOARD_NUM = 1;

--조회수 변경
UPDATE BOARD SET BOARD_CNT = ? WHERE BOARD_NUM = ?;

-- BOARD 테이블 삭제
DROP TABLE BOARD;