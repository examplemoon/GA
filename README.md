# 📊 급여에서 포트폴리오로: ETF에 적용된 개인 급여 투자자를 위한 새로운 가우시안 평준화 투자 접근법

이 프로젝트는 **개인 급여 투자자**를 위한 새로운 투자전략인 **가우시안 평준화(GA: Gaussian Averaging)** 기법을 제안하고, 이를 전통적 투자 전략(DCA, VA)와 비교 평가합니다.

---

## 🧠 주요 전략

- **DCA (Dollar-Cost Averaging)** : 일정 금액을 정기적으로 투자
- **VA (Value Averaging)** : 자산 가치 증가에 따라 투자 금액을 조절
- **GA (Gaussian Averaging)** : 주가가 평균에서 얼마나 벗어났는지를 통계적으로 판단하여 투자 비중을 조정

---

## 📁 파일 구성

| 파일명             | 설명 |
|--------------------|------|
| `GA_1.Rmd`         | 전체 분석이 담긴 R Markdown 문서 |
| `load_packages.R`  | 필요한 R 패키지 자동 설치 및 로딩 |
| `data_utils.R`     | 주가 데이터 수집 및 전처리 함수 |
| `strategies.R`     | DCA, VA, GA 전략 함수 정의 |
| `metrics.R`        | ROI, IRR, Sharpe 비율 등 성과지표 계산 |
| `simulation.R`     | 다양한 시나리오 기반의 투자 시뮬레이션 |
| `test.R`           | 실제 ETF(QQQ, DIA, SPY) 분석 및 결과 시각화 |

---

## ▶️ 실행 방법

```r
# 1. 패키지 설치 및 로딩
source("load_packages.R")

# 2. 함수 불러오기
source("data_utils.R")
source("strategies.R")
source("metrics.R")

# 3. 테스트 실행 (synthetic + 실제 ETF 분석)
source("test.R")

# 4. 또는 시나리오 기반 분석 실행
source("simulation.R")
```

---

## 📌 논문 정보

> 문예준, 김남형 (2025).  
> **급여에서 포트폴리오로: ETF에 적용된 개인 급여 투자자를 위한 새로운 가우시안 평준화 투자 접근법**  
> 가천대학교 응용통계학과 석사과정  
> 한국연구재단 지원 연구과제 (No. 2021R1F1A1050602)

---

## 📬 문의

- 제1저자: 문예준 (ansd@gachon.ac.kr)  
- 교신저자: 김남형 부교수 (nhkim@gachon.ac.kr)
