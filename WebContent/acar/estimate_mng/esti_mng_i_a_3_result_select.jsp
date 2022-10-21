<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.common.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	EstiDatabase e_db = EstiDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	

	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");

	String vid[] = request.getParameterValues("ch_l_cd");
	int vid_size = vid.length;
	
	Hashtable ht2 = new Hashtable();
	Vector vt = new Vector();
	
	for(int i=0; i < vid_size; i++){
		
		String est_id = vid[i];		
		String est_st = vid[i].substring(0,1);
		est_id = est_id.substring(1);
		
		if(est_st.equals("1")){
			ht2 = e_db.getEstiMateSelectResult(est_id);
		}else if(est_st.equals("2")){
			ht2 = e_db.getEstiMateSelectResultSh(est_id);
		}else if(est_st.equals("3")){
			ht2 = e_db.getEstiMateSelectResultCu(est_id);
		}
		
		vt.add(ht2);
		
	}
	
	int vt_size = vt.size();
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript">
<!--

//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >
<table border=0 cellspacing=0 cellpadding=0 width=<%=550+(150*vt_size)%>>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>견적관리 > <span class=style5>견적결과</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right"></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>  
	<tr> 
      <td>
        <table width=100% border="0" cellspacing="0" cellpadding="0">
          <tr> 
		    <td class="line">
			  <table width=400 border="0" cellspacing="1" cellpadding="0">
			    <tr> 
				  <td class=title>구분(1:직원s, 2:재리스, 3:고객)</td>
				</tr>
                <tr> 
				  <td class=title>견적번호</td>
				</tr>
				<tr> 
				  <td class=title>등록코드</td>
				</tr>
				<tr> 
				  <td class=title>등록일시</td>
				</tr>
				<tr> 
				  <td class=title>등록자</td>
				</tr>
                <tr> 
				  <td class=title>차종코드</td>
				</tr>
                <tr> 
				  <td class=title>계약일자</td>
				</tr>
				<tr> 
				  <td class=title>상품</td>
				</tr>
                <tr> 
				  <td class=title>이용기간</td>
				</tr>
				<tr> 
				  <td class=title>est_from</td>
				</tr>
				<tr> 
				  <td class=title>약정주행거리</td>
				</tr>
				<tr> 
				  <td class=title>최대개월수</td>
				</tr>
				<tr> 
				  <td class=title>표준최대잔가</td>
				</tr>
				<tr> 
				  <td class=title>최대잔가조정치</td>
				</tr>
				<tr> 
				  <td class=title>조정최대잔가</td>
				</tr>
                <tr> 
				  <td class=title>적용잔가율</td>
				</tr>
				<tr> 
				  <td class=title>적용잔가</td>
				</tr>
                <tr> 
				  <td class=title>현시점 차령24개월 잔가율</td>
				</tr>
                <tr> 
				  <td class=title>2년후 차령24개월 잔가율</td>
				</tr>
                <tr> 
				  <td class=title>최저잔가율</td>
				</tr>
                <tr> 
				  <td class=title>차령 적용 평균잔가율(대여종료 시점 기준)</td>
				</tr>
                <tr> 
				  <td class=title>대여종료시점 기본차량 잔가율</td>
				</tr>
                <tr> 
				  <td class=title>대여종료 시점 중고차가1</td>
				</tr>
                <tr> 
				  <td class=title>대여종료 시점 중고차가2</td>
				</tr>
                <tr> 
				  <td class=title>대여종료 시점 중고차가</td>
				</tr>
                <tr> 
				  <td class=title>차량가격 적용 잔가율</td>
				</tr>
                <tr> 
				  <td class=title>신차등록일-전년도말일</td>
				</tr>
                <tr> 
				  <td class=title>신차등록월 반영 잔가율</td>
				</tr>
                <tr> 
				  <td class=title>36개월 초과견적시 잔가 조정값</td>
				</tr>
                <tr> 
				  <td class=title>신차견적시 최대잔가율</td>
				</tr>
                <tr> 
				  <td class=title>예상 총주행거리</td>
				</tr>
                <tr> 
				  <td class=title>중고차잔가 산정용 계약기간 총표준주행거리</td>
				</tr>				
                <tr> 
				  <td class=title>표준주행거리 대비 예상주행거리 차이</td>
				</tr>
                <tr> 
				  <td class=title>중고차가 조정율</td>
				</tr>				
                <tr> 
				  <td class=title>예상주행거리 반영 최대잔가율</td>
				</tr>	
                <tr> 
				  <td class=title>(재)현시점 기본차량 잔가율</td>
				</tr>					
                <tr> 
				  <td class=title>(재)주행거리에 따른 중고차가 조정율</td>
				</tr>					
                <tr> 
				  <td class=title>(재)주행거리에 따른 중고차가 조정율</td>
				</tr>	
                <tr> 
				  <td class=title>(재)현시점 중고차가(주행거리반영,낙찰가)</td>
				</tr>									
                <tr> 
				  <td class=title>(재)현시점 경매장 예상낙찰가(주행거리반영)</td>
				</tr>	
                <tr> 
				  <td class=title>(재)재리스종료시점 예상잔가율(현시점경매장예상)</td>
				</tr>	
                <tr> 
				  <td class=title>(재)재리스종료시점 적용잔가율(현시점경매장)</td>
				</tr>									
                <tr> 
				  <td class=title>(재)재리스 및 연장계약 견적 적용잔가율</td>
				</tr>	
                <tr> 
				  <td class=title>(재)중고차 시장변환에 따른 리스크를 감안한 적용잔가율</td>
				</tr>					
                <tr> 
				  <td class=title>(재)중고차 리스견적 적용잔가율(최종)</td>
				</tr>											
				
				<tr> 
				  <td class=title>ADD_O_13</td>
				</tr>
				<tr> 
				  <td class=title>ACCID_SIK_J</td>
				</tr>
				<tr> 
				  <td class=title>JG_B_DT</td>
				</tr>
				<tr> 
				  <td class=title>EM_A_J</td>
				</tr>
				<tr> 
				  <td class=title>EA_A_J</td>
				</tr>
				<tr> 
				  <td class=title>P_O_1</td>
				</tr>
				<tr> 
				  <td class=title>JG_C_1</td>
				</tr>
				<tr> 
				  <td class=title>O_Q1</td>
				</tr>
				<tr> 
				  <td class=title>O_Q2</td>
				</tr>
				<tr> 
				  <td class=title>O_Q3</td>
				</tr>
				<tr> 
				  <td class=title>O_Q4</td>
				</tr>
				<tr> 
				  <td class=title>G_9</td>
				</tr>
				<tr> 
				  <td class=title>G_10</td>
				</tr>
				<tr> 
				  <td class=title>A_M_4</td>
				</tr>
				<tr> 
				  <td class=title>O_T</td>
				</tr>
				<tr> 
				  <td class=title>T_BD</td>
				</tr>
				<tr> 
				  <td class=title>GB917</td>
				</tr>
				<tr> 
				  <td class=title>FW917</td>
				</tr>
				<tr> 
				  <td class=title>V_VAR1</td>
				</tr>
				<tr> 
				  <td class=title>V_VAR2</td>
				</tr>
				<tr> 
				  <td class=title>V_VAR3</td>
				</tr>
				<tr> 
				  <td class=title>N_VAR1</td>
				</tr>
				<tr> 
				  <td class=title>N_VAR2</td>
				</tr>
				<tr> 
				  <td class=title>N_VAR3</td>
				</tr>
				<tr> 
				  <td class=title>BC_B_E1</td>
				</tr>
				<tr> 
				  <td class=title>BC_B_E2</td>
				</tr>
				<tr> 
				  <td class=title>ETC</td>
				</tr>
				<tr> 
				  <td class=title>A_M_3</td>
				</tr>
								
                <tr> 
				  <td class=title>1위 사고수리비</td>
				</tr>															
                <tr> 
				  <td class=title>2위 사고수리비</td>
				</tr>															
                <tr> 
				  <td class=title>색상 및 사양 잔가반영</td>
				</tr>															
                <tr> 
				  <td class=title>TUIX/TUON 트림/옵션 여부</td>
				</tr>									
                <tr> 
				  <td class=title>첨단안전사양</td>
				</tr>	
				<tr> 
				  <td class=title>첨단안전사양</td>
				</tr>
				<tr> 
				  <td class=title>첨단안전사양</td>
				</tr>
				<tr> 
				  <td class=title>첨단안전사양</td>
				</tr>
				<tr> 
				  <td class=title>첨단안전사양</td>
				</tr>
				<tr> 
				  <td class=title>첨단안전사양/견인고리(할증율)</td>
				</tr>
				<tr> 
				  <td class=title>첨단안전사양/견인고리(할증율)</td>
				</tr>
				<tr> 
				  <td class=title>개소세관련 인상금액</td>
				</tr>								
                <tr> 
				  <td class=title>대여료(공급가)</td>
				</tr>	
                <tr> 
				  <td class=title>차량가격</td>
				</tr>	
                <tr> 
				  <td class=title>제조사DC금액</td>
				</tr>	
                <tr> 
				  <td class=title>차량구입가</td>
				</tr>				
                <tr> 
				  <td class=title>차량구입가(공급가)</td>
				</tr>				
                <tr> 
				  <td class=title>과세표준액</td>
				</tr>				
                <tr> 
				  <td class=title>등록세</td>
				</tr>				
                <tr> 
				  <td class=title>취득세</td>
				</tr>				
                <tr> 
				  <td class=title>결정채권매입액</td>
				</tr>				
                <tr> 
				  <td class=title>채권할인</td>
				</tr>				
                <tr> 
				  <td class=title>대출액</td>
				</tr>				
                <tr> 
				  <td class=title>대출관련인지대</td>
				</tr>				
                <tr> 
				  <td class=title>대출관련설정료</td>
				</tr>				
                <tr> 
				  <td class=title>영업사원수당</td>
				</tr>				
                <tr> 
				  <td class=title>부대비용</td>
				</tr>				
                <tr> 
				  <td class=title>Cash Back</td>
				</tr>				
                <tr> 
				  <td class=title>특소세환입액출고시 현재가치</td>
				</tr>				
                <tr> 
				  <td class=title>취득원가</td>
				</tr>				
                <tr> 
				  <td class=title>월리스원금</td>
				</tr>				
                <tr> 
				  <td class=title>자동차세</td>
				</tr>				
                <tr> 
				  <td class=title>환경개선부담금</td>
				</tr>				
                <tr> 
				  <td class=title>년총보험비용</td>
				</tr>				
                <tr> 
				  <td class=title>월보험비용</td>
				</tr>				
                <tr> 
				  <td class=title>기본식일반관리비</td>
				</tr>				
                <tr> 
				  <td class=title>일반식추가관리비</td>
				</tr>				
                <tr> 
				  <td class=title>기본식월관리비</td>
				</tr>				
                <tr> 
				  <td class=title>일반식월관리비</td>
				</tr>				
                <tr> 
				  <td class=title>기본식 반영전 원가</td>
				</tr>				
                <tr> 
				  <td class=title>기본식대여료(공급가)</td>
				</tr>				
                <tr> 
				  <td class=title>일반식 반영전 원가</td>
				</tr>				
                <tr> 
				  <td class=title>일반식 대여료(공급가)</td>
				</tr>				
                <tr> 
				  <td class=title>잔가할인율적용</td>
				</tr>
				<tr> 
				  <td class=title>보증금</td>
				</tr>					
                <tr> 
				  <td class=title>보증금효과</td>
				</tr>				
                <tr> 
				  <td class=title>선납금효과</td>
				</tr>				
                <tr> 
				  <td class=title>개시대여료효과</td>
				</tr>				
                <tr> 
				  <td class=title>보증금율</td>
				</tr>				
                <tr> 
				  <td class=title>예상주행거리</td>
				</tr>				
                <tr> 
				  <td class=title>약정주행거리</td>
				</tr>				
                <tr> 
				  <td class=title>초과운행부담금</td>
				</tr>		
				<tr> 
				  <td class=title>환급대여료</td>
				</tr>			
                <tr> 
				  <td class=title>적용위약율</td>
				</tr>				
                <tr> 
				  <td class=title>필요위약율</td>
				</tr>				
                <tr> 
				  <td class=title>이용기간종료시가치</td>
				</tr>				
                <tr> 
				  <td class=title>잔여기간총대여료</td>
				</tr>				
                <tr> 
				  <td class=title>AX81</td>
				</tr>				
                <tr> 
				  <td class=title>할부구입대비</td>
				</tr>											
			  </table>	
			</td>		  
		    <td class="line">
			  <table width=150 border="0" cellspacing="1" cellpadding="0">
                <tr> 
				  <td class=title>ST</td>
				</tr>
				<tr> 
				  <td class=title>EST_ID</td>
				</tr>
				<tr> 
				  <td class=title>REG_CODE</td>
				</tr>
				<tr> 
				  <td class=title>REG_DT</td>
				</tr>
				<tr> 
				  <td class=title>REG_ID</td>
				</tr>
                <tr> 
				  <td class=title>JG_CODE</td>
				</tr>
                <tr> 
				  <td class=title>RENT_DT</td>
				</tr>
				<tr> 
				  <td class=title>A_A</td>
				</tr>
                <tr> 
				  <td class=title>A_B</td>
				</tr>
				<tr> 
				  <td class=title>est_from</td>
				</tr>
				<tr> 
				  <td class=title>agree_dist</td>
				</tr>
				<tr> 
				  <td class=title>max_use_mon</td>
				</tr>
                <tr> 
				  <td class=title>B_O_13</td>
				</tr>
				<tr> 
				  <td class=title>ADD_O_13</td>
				</tr>
				<tr> 
				  <td class=title>O_13</td>
				</tr>
				<tr> 
				  <td class=title>RO_13</td>
				</tr>
				<tr> 
				  <td class=title>RO_13_AMT</td>
				</tr>
                <tr> 
				  <td class=title>O_B</td>
				</tr>
                <tr> 
				  <td class=title>O_C</td>
				</tr>
                <tr> 
				  <td class=title>O_D</td>
				</tr>
                <tr> 
				  <td class=title>O_E</td>
				</tr>
                <tr> 
				  <td class=title>O_F</td>
				</tr>
                <tr> 
				  <td class=title>O_G1</td>
				</tr>
                <tr> 
				  <td class=title>O_G2</td>
				</tr>
                <tr> 
				  <td class=title>O_G</td>
				</tr>
                <tr> 
				  <td class=title>O_H</td>
				</tr>
                <tr> 
				  <td class=title>DAY</td>
				</tr>
                <tr> 
				  <td class=title>O_I</td>
				</tr>
                <tr> 
				  <td class=title>O_K</td>
				</tr>
                <tr> 
				  <td class=title>O_M</td>
				</tr>
                <tr> 
				  <td class=title>BM7</td>
				</tr>
                <tr> 
				  <td class=title>BM9</td>
				</tr>				
                <tr> 
				  <td class=title>BM10</td>
				</tr>
                <tr> 
				  <td class=title>BM12</td>
				</tr>				
                <tr> 
				  <td class=title>BM14</td>
				</tr>				
                <tr> 
				  <td class=title>O_F_R</td>
				</tr>					
                <tr> 
				  <td class=title>O_R</td>
				</tr>					
                <tr> 
				  <td class=title>O_R_R</td>
				</tr>	
                <tr> 
				  <td class=title>O_S_R</td>
				</tr>									
                <tr> 
				  <td class=title>O_S</td>
				</tr>	
                <tr> 
				  <td class=title>O_U</td>
				</tr>	
                <tr> 
				  <td class=title>O_V</td>
				</tr>									
                <tr> 
				  <td class=title>O_W</td>
				</tr>	
                <tr> 
				  <td class=title>O_X</td>
				</tr>					
                <tr> 
				  <td class=title>O_Y</td>
				</tr>	
				
				<tr> 
				  <td class=title>ADD_O_13</td>
				</tr>
				<tr> 
				  <td class=title>ACCID_SIK_J</td>
				</tr>
				<tr> 
				  <td class=title>JG_B_DT</td>
				</tr>
				<tr> 
				  <td class=title>EM_A_J</td>
				</tr>
				<tr> 
				  <td class=title>EA_A_J</td>
				</tr>
				<tr> 
				  <td class=title>P_O_1</td>
				</tr>
				<tr> 
				  <td class=title>JG_C_1</td>
				</tr>
				<tr> 
				  <td class=title>O_Q1</td>
				</tr>
				<tr> 
				  <td class=title>O_Q2</td>
				</tr>
				<tr> 
				  <td class=title>O_Q3</td>
				</tr>
				<tr> 
				  <td class=title>O_Q4</td>
				</tr>
				<tr> 
				  <td class=title>G_9</td>
				</tr>
				<tr> 
				  <td class=title>G_10</td>
				</tr>
				<tr> 
				  <td class=title>A_M_4</td>
				</tr>
				<tr> 
				  <td class=title>O_T</td>
				</tr>
				<tr> 
				  <td class=title>T_BD</td>
				</tr>
				<tr> 
				  <td class=title>GB917</td>
				</tr>
				<tr> 
				  <td class=title>FW917</td>
				</tr>
				<tr> 
				  <td class=title>V_VAR1</td>
				</tr>
				<tr> 
				  <td class=title>V_VAR2</td>
				</tr>
				<tr> 
				  <td class=title>V_VAR3</td>
				</tr>
				<tr> 
				  <td class=title>N_VAR1</td>
				</tr>
				<tr> 
				  <td class=title>N_VAR2</td>
				</tr>
				<tr> 
				  <td class=title>N_VAR3</td>
				</tr>
				<tr> 
				  <td class=title>BC_B_E1</td>
				</tr>
				<tr> 
				  <td class=title>BC_B_E2</td>
				</tr>
				<tr> 
				  <td class=title>ETC</td>
				</tr>
				<tr> 
				  <td class=title>A_M_3</td>
				</tr>
																				
                <tr> 
				  <td class=title>accid_serv_amt1</td>
				</tr>																	
                <tr> 
				  <td class=title>accid_serv_amt2</td>
				</tr>																	
                <tr> 
				  <td class=title>jg_opt_st</td>
				</tr>																	
                <tr> 
				  <td class=title>jg_tuix_st</td>
				</tr>																	
                <tr> 
				  <td class=title>lkas_yn</td>
				</tr>	
				<tr> 
				  <td class=title>ldws_yn</td>
				</tr>
				<tr> 
				  <td class=title>aeb_yn</td>
				</tr>
				<tr> 
				  <td class=title>fcw_yn</td>
				</tr>
				<tr> 
				  <td class=title>hook_yn</td>
				</tr>
				<tr> 
				  <td class=title>bk_172</td>
				</tr>
				<tr> 
				  <td class=title>bk_182</td>
				</tr>
				<tr> 
				  <td class=title>BK_190</td>
				</tr>																	
                <tr> 
				  <td class=title>FEE_S_AMT</td>
				</tr>	
                <tr> 
				  <td class=title>O_1</td>
				</tr>	
                <tr> 
				  <td class=title>DC_AMT</td>
				</tr>	
                <tr> 
				  <td class=title>S_A</td>
				</tr>				
                <tr> 
				  <td class=title>S_C</td>
				</tr>				
                <tr> 
				  <td class=title>S_D</td>
				</tr>				
                <tr> 
				  <td class=title>S_E</td>
				</tr>				
                <tr> 
				  <td class=title>S_G</td>
				</tr>				
                <tr> 
				  <td class=title>S_H</td>
				</tr>				
                <tr> 
				  <td class=title>S_J</td>
				</tr>				
                <tr> 
				  <td class=title>S_K</td>
				</tr>				
                <tr> 
				  <td class=title>S_M</td>
				</tr>				
                <tr> 
				  <td class=title>S_Q</td>
				</tr>				
                <tr> 
				  <td class=title>S_R</td>
				</tr>				
                <tr> 
				  <td class=title>S_S</td>
				</tr>				
                <tr> 
				  <td class=title>K_CB_3</td>
				</tr>				
                <tr> 
				  <td class=title>S_V</td>
				</tr>				
                <tr> 
				  <td class=title>S_W</td>
				</tr>				
                <tr> 
				  <td class=title>K_N</td>
				</tr>				
                <tr> 
				  <td class=title>K_R</td>
				</tr>				
                <tr> 
				  <td class=title>K_TT</td>
				</tr>				
                <tr> 
				  <td class=title>K_CH</td>
				</tr>				
                <tr> 
				  <td class=title>C_S</td>
				</tr>				
                <tr> 
				  <td class=title>G_6</td>
				</tr>				
                <tr> 
				  <td class=title>G_7</td>
				</tr>				
                <tr> 
				  <td class=title>K_T</td>
				</tr>				
                <tr> 
				  <td class=title>K_P</td>
				</tr>				
                <tr> 
				  <td class=title>K_H</td>
				</tr>				
                <tr> 
				  <td class=title>K_MM</td>
				</tr>				
                <tr> 
				  <td class=title>K_BB</td>
				</tr>				
                <tr> 
				  <td class=title>K_CC</td>
				</tr>				
                <tr> 
				  <td class=title>K_JD</td>
				</tr>	
				<tr> 
				  <td class=title>GTR_AMT</td>
				</tr>			
                <tr> 
				  <td class=title>K_MO</td>
				</tr>				
                <tr> 
				  <td class=title>K_SO</td>
				</tr>				
                <tr> 
				  <td class=title>K_WO</td>
				</tr>				
                <tr> 
				  <td class=title>RG_8</td>
				</tr>				
                <tr> 
				  <td class=title>TODAY_DIST</td>
				</tr>				
                <tr> 
				  <td class=title>AGREE_DIST</td>
				</tr>				
                <tr> 
				  <td class=title>OVER_RUN_AMT</td>
				</tr>		
				<tr> 
				  <td class=title>RTN_RUN_AMT</td>
				</tr>			
                <tr> 
				  <td class=title>CLS_PER</td>
				</tr>				
                <tr> 
				  <td class=title>CLS_N_PER</td>
				</tr>				
                <tr> 
				  <td class=title>BK60</td>
				</tr>				
                <tr> 
				  <td class=title>BK61</td>
				</tr>				
                <tr> 
				  <td class=title>AX81</td>
				</tr>				
                <tr> 
				  <td class=title>AE93</td>
				</tr>											
			  </table>	
			</td>				
			<% 	if(vt.size()>0){
					for(int i=0; i<vt.size(); i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);%>		  
		    <td class="line">
			  <table width=150 border="0" cellspacing="1" cellpadding="0">
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("ST")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("EST_ID")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("REG_CODE")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("REG_DT")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("REG_ID")%></td>				  
				</tr>
                <tr> 
				  <td  class=title style="font-size : 8pt;"><%=ht.get("JG_CODE")%></td>
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("RENT_DT")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=c_db.getNameByIdCode("0009", "", String.valueOf(ht.get("A_A")))%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("A_B")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("EST_FROM")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("AGREE_DIST")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("MAX_USE_MON")%></td>				  
				</tr>
                <tr> 
				  <td class=title style="font-size : 8pt;"><%=ht.get("B_O_13")%>%</td>				  
				</tr>
				<tr> 
				  <td class=title style="font-size : 8pt;"><%=ht.get("ADD_O_13")%></td>				  
				</tr>
				<tr> 
				  <td class=title style="font-size : 8pt;"><%=ht.get("O_13")%>%</td>				  
				</tr>
				<tr> 
				  <td class=title style="font-size : 8pt;"><%=ht.get("RO_13")%>%</td>				  
				</tr>
				<tr> 
				  <td class=title style="font-size : 8pt;"><%=ht.get("RO_13_AMT")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_B")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_C")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_D")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_E")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_F")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_G1")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_G2")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_G")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_H")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("DAY")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_I")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_K")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_M")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BM7")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BM9")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BM10")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BM12")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BM14")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_F_R")%></td>				  
				</tr>					
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_R")%></td>
				</tr>					
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_R_R")%></td>
				</tr>	
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_S_R")%></td>
				</tr>									
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_S")%></td>
				</tr>	
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_U")%></td>
				</tr>	
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_V")%></td>
				</tr>									
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_W")%></td>
				</tr>	
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_X")%></td>
				</tr>					
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_Y")%></td>
				</tr>		
				
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("ADD_O_13")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("ACCID_SIK_J")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("JG_B_DT")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("EM_A_J")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("EA_A_J")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("P_O_1")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("JG_C_1")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_Q1")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_Q2")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_Q3")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_Q4")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("G_9")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("G_10")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("A_M_4")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_T")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("T_BD")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("GB917")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("FW917")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("V_VAR1")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("V_VAR2")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("V_VAR3")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("N_VAR1")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("N_VAR2")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("N_VAR3")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BC_B_E1")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BC_B_E2")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("ETC")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("A_M_3")%></td>
				</tr>
														
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("ACCID_SERV_AMT1")%></td>
				</tr>									
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("ACCID_SERV_AMT2")%></td>
				</tr>									
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("JG_OPT_ST")%> <%=ht.get("JG_COL_ST")%></td>
				</tr>									
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("JG_TUIX_ST")%> <%=ht.get("JG_TUIX_OPT_ST")%></td>
				</tr>									
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("LKAS_YN")%></td>				  
				</tr>	
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("LDWS_YN")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("AEB_YN")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("FCW_YN")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("HOOK_YN")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BK_172")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BK_182")%></td>				  
				</tr>
				<tr> 
				  <td class=title style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("BK_190")))%>원</td>				  
				</tr>								
                <tr> 
				  <td class=title style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%>원</td>				  
				</tr>
                <tr> 
				  <td class=title style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("O_1")))%>원</td>				  
				</tr>
                <tr> 
				  <td class=title style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("DC_AMT")))%>원</td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_A")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_C")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_D")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_E")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_G")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_H")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_J")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_K")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_M")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_Q")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_R")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_S")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_CB_3")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_V")%></td>				  
				</tr>
                <tr> 
				  <td class="is" align="center" style="font-size : 8pt;" ><%=AddUtil.parseDecimal(String.valueOf(ht.get("S_W")))%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_N")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_R")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_TT")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_CH")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("C_S")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("G_6")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("G_7")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_T")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_P")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_H")%></td>				  
				</tr>				
                <tr> 
				  <td class="is" align="center" style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("K_MM")))%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_BB")%></td>				  
				</tr>				
                <tr> 
				  <td class="is" align="center" style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("K_CC")))%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_JD")%></td>				  
				</tr>	
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("GTR_AMT")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_MO")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_SO")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_WO")%></td>				  
				</tr>	
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("RG_8")%>%</td>				  
				</tr>	
                <tr> 
				  <td class=title style="font-size : 8pt;"><%=ht.get("TODAY_DIST")%></td>
				</tr>				
                <tr> 
				  <td class=title style="font-size : 8pt;"><%=ht.get("AGREE_DIST")%></td>
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("OVER_RUN_AMT")%></td>
				</tr>		
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("RTN_RUN_AMT")%></td>
				</tr>			
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("CLS_PER")%>%</td>
				</tr>											
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("CLS_N_PER")%>%</td>
				</tr>											
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BK60")%></td>
				</tr>											
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BK61")%></td>
				</tr>											
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("AX81")%></td>
				</tr>											
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("AE93")%></td>
				</tr>											
			  </table>	
			</td>
			<%		}
				}%>
		  </tr>
		</table>
	  </td>
	</tr>  	  	
</form>

</body>
</html>
