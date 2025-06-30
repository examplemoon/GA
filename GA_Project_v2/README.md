# Genetic‑Algorithm Stock Strategy 📈

유전 알고리즘(GA)을 활용하여 **Value Averaging**, **Dollar Cost Averaging**,
그리고 두 전략을 혼합한 **GA Hybrid** 투자 전략을 비교·평가합니다.

## 구조

```
GA_Project/
├── R/                # 기능별 R 모듈
├── scripts/          # 실행 스크립트
├── data/             # 원본/가공 데이터
├── report/           # 원본 RMarkdown
└── README.md
```

## 사용 방법

```r
# 터미널
Rscript scripts/run_analysis.R
```

결과는 `data/processed/metrics_result.csv` 에 저장됩니다. 
필요에 따라 티커·기간·무위험수익률 등을 `scripts/run_analysis.R` 에서 조정하세요.