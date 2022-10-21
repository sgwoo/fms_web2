<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	
    String s_user =  request.getParameter("user_id")==null?"":request.getParameter("user_id");	
   
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");	
	String popup = request.getParameter("popup")==null?"":request.getParameter("popup");	
   
    String dt		= "4";


	int cnt = 2; //현황 출력 총수
	int sh_height = cnt*sh_line_height;
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-150;//현황 라인수만큼 제한 아이프레임 사이즈
	
	
//비용캠페인변수 : cost_campaign 테이블
	Hashtable ht3 = ac_db.getCostCampaignVar("2");
	
	String year 		= (String)ht3.get("YEAR");
	String tm 			= (String)ht3.get("TM");
	String cs_dt 		= (String)ht3.get("CS_DT");
	String ce_dt 		= (String)ht3.get("CE_DT");

	int amt1 			= AddUtil.parseInt((String)ht3.get("AMT1"));  //일반정비비 한도
	int amt1_per 		= AddUtil.parseInt((String)ht3.get("AMT1_PER")); //한도
	int amt2 			= AddUtil.parseInt((String)ht3.get("AMT2"));  //사고수리비 한도
	int amt2_per 		= AddUtil.parseInt((String)ht3.get("AMT2_PER")); //한도
	int amt3 			= AddUtil.parseInt((String)ht3.get("AMT3"));
	int rent_way_1_per 		= AddUtil.parseInt((String)ht3.get("RENT_WAY_1_PER"));
	int rent_way_2_per 	= AddUtil.parseInt((String)ht3.get("RENT_WAY_2_PER"));
	int max_day			= AddUtil.parseInt((String)ht3.get("MAX_DAY"));
		
	int cam_per 		= AddUtil.parseInt((String)ht3.get("CAM_PER"));
	
	int cc1 			= AddUtil.parseInt((String)ht3.get("CC1"));
	int cc2	 			= AddUtil.parseInt((String)ht3.get("CC2"));
	int cc3 			= AddUtil.parseInt((String)ht3.get("CC3"));
	int cc4 			= AddUtil.parseInt((String)ht3.get("CC4"));
	
	int da_amt1 		= AddUtil.parseInt((String)ht3.get("DA_AMT1"));
	int da_amt2 		= AddUtil.parseInt((String)ht3.get("DA_AMT2"));
	int da_amt3 		= AddUtil.parseInt((String)ht3.get("DA_AMT3"));
	
	int bus_cost_per 		= AddUtil.parseInt((String)ht3.get("BUS_COST_PER"));
	int mng_cost_per 		= AddUtil.parseInt((String)ht3.get("MNG_COST_PER"));
		
	int car_cnt 		= AddUtil.parseInt((String)ht3.get("CAR_CNT"));
	int sale_cnt 		= AddUtil.parseInt((String)ht3.get("SALE_CNT"));	
	int base_cnt 		= AddUtil.parseInt((String)ht3.get("BASE_CNT"));	
				
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDt("stat_bus_cost_2_cmp");

			
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--


//팝업윈도우 열기
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}	


//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>"> 
<input type="hidden" name="gubun" value="3"> 
<input type="hidden" name="from_page" value="/fms2/mis/man_cost3_jung.jsp"> 

<table border="0" cellspacing="0" cellpadding="0" width="100%">

	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 비용관리 > <span class=style5>월평균관리비용현황(2군)</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>     
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_campaign.gif align=absmiddle>&nbsp;
        <input type="text" name="ccs_dt" size="11" value="<%= AddUtil.ChangeDate2(cs_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
        ~ 
        <input type="text" name="cce_dt" size="11" value="<%= AddUtil.ChangeDate2(ce_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'></td>
    </tr>
    <tr>
        <td><div align="right"><img src=/acar/images/center/arrow_gjij.gif align=absmiddle> <%= AddUtil.ChangeDate2(save_dt)%> </td>
    </tr> 
    <tr> 
        <td colspan="4"><iframe src="./man_cost3_jung_view.jsp?auth_rw=<%=auth_rw%>&user_id=<%=s_user%>" name="i_view" width="100%" height="550" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
</table>    

<br>
<!-- 평가기준 -->
<% if (!popup.equals("Y")) { %>
<table width="1000" border="0" cellspacing="0" cellpadding="0">
	<tr> 
      <td colspan=2><font color="#FF00FF">♣ 포상일</font>       : FMS에 데이타 입력시간 등을 고려하여 캠페인 마감일기준 20일 전후로 포상일이 결정됩니다.  
        &nbsp;&nbsp;</td>
   	</tr> 
  	<tr> 
        <td colspan=2><font color="#FF00FF">♣ 관리비용</font> : ((본인기본식1대당평균비용/전체기본식1대당평균비용)*(본인기본식총비용/본인총비용)+(본인일반식1대당평균비용/전체일반식1대당평균비용)*(본인일반식총비용/본인총비용))*1대당평균관리비용(전체비용/전체대수) </td> 
              
    </tr>
   	<tr> 
      <td colspan=2><font color="#FF00FF">♣ 재리스 정비</font> : 기본식-> 영업효율에 반영, 일반식->대여개시 2개월이전:영업효율에 반영, 대여개시 2개월이후:일반정비비로 반영</td>
   	</tr>
   	<tr> 
      <td>&nbsp;&nbsp;&nbsp;</td>
      <td><font color=red>(</font> 
       
		정비관련 대차비용, 탁송비용, 탁송유류대도 위의 재리스 정비와 동일하게 적용 <font color=red>)</font>
		</td>	
    </tr>
   <!--	
    <tr> 
      <td colspan=2><font color="#999999"><font color="#FF00FF">♣ 휴대폰 정산방법</font> : 평균사용료(본사/지점별 1군/2군 평균)의 초과(미만)금액 10배 할증(차감)</td>
   	</tr>
   	<tr> 
      <td colspan=2><font color="#999999"><font color="#FF00FF">♣ 유류대(활동비) 정산방법</font> : 평균사용료(본사/지점별 1군/2군 평균)의 초과(미만)금액 5배 할증(차감)</td>
   	</tr>   	
 
    <tr> 
        <td colspan=2><font color="#FF00FF">♣ 차량관리대수</font> : 캠페인 기간내의 평균관리대수</font></td>    
    </tr>
  -->  
    <tr> 
      <td colspan=2><font color="#FF00FF">♣ 포상금액</font>     : (1대당평균관리비용- 본인1대당평균관리비용)* 관리대수</td>
    </tr>
  
    <tr> 
      <td width="100">&nbsp;&nbsp;&nbsp;1. 평가기준기간</td>
      <td>: 
        <input type="text" name="cs_dt" size="11" value="<%= AddUtil.ChangeDate2(cs_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
		~
		<input type="text" name="ce_dt" size="11" value="<%= AddUtil.ChangeDate2(ce_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
	</tr>
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;2. 기준금액</td>
      <td>: 
       	일반정비비 최대적용금액: <input type="text" name="amt1" size="11" value="<%= AddUtil.parseDecimal(amt1) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
		원&nbsp;&nbsp;초과금액 반영률: <input type="text" name="amt1_per" size="3" value="<%= AddUtil.parseDecimal(amt1_per) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>%
		</td>	
    </tr>
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;</td>
      <td>: 
       
		사고수리비 최대적용금액: <input type="text" name="amt2" size="11" value="<%= AddUtil.parseDecimal(amt2) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
		원&nbsp;&nbsp;초과금액 반영률: <input type="text" name="amt2_per" size="3" value="<%= AddUtil.parseDecimal(amt2_per) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>%
		</td>	
    </tr>
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;</td>
      <td>: 
       
		기타, 활동비용: 100% 반영
		</td>	
    </tr>
    
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;3. 분배기준</td>
      <td>: 
        비용 및 매출 발생시:&nbsp;&nbsp; 최초영업자<input type="text" name="bus_cost_per" size="3" value="<%= AddUtil.parseDecimal(bus_cost_per) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'> %
        &nbsp;&nbsp; 관리담당자:<input type="text" name="mng_cost_per" size="3" value="<%= AddUtil.parseDecimal(mng_cost_per) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'> %
	  </td>
	</tr>
	
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;4. 대차기준</td>
      <td>: 
        실대차일&nbsp;&nbsp; * 기준값:보유차(매월1일 산정)의 월대여료의 1일 대여료
	  </td>
	</tr>
	
	<tr> 
      <td>&nbsp;&nbsp;&nbsp;5. 캠페인대수</td>
      <td>: 
        캠페인 기간내 평균관리대수:<input type="text" name="car_cnt" readonly size="3" value="<%= AddUtil.parseDecimal(car_cnt) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'> %,
        &nbsp;&nbsp; 캠페인 기간내 매출에 따른 계산된 관리대수:<input type="text" name="sale_cnt"  readonly size="3" value="<%= AddUtil.parseDecimal(sale_cnt) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'> %,
        &nbsp;&nbsp; 포상기준대수: <input type="text" name="base_cnt" size="3" value="<%= AddUtil.parseDecimal(base_cnt) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>대 이상 
       </td>
	</tr>
	
  <!--  
    <tr>
	    <td>&nbsp;&nbsp;&nbsp;</td>  	
	    <td>: 
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="text" name="cc2" size="9" value="<%= AddUtil.parseDecimal(cc2) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'> ~ <input type="text" name="cc3" size="9" value="<%= AddUtil.parseDecimal(cc3) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'> cc  &nbsp;&nbsp;<input type="text" name="da_amt2" size="11" value="<%= AddUtil.parseDecimal(da_amt2) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>원&nbsp;&nbsp;

		&nbsp;&nbsp;
		</td>
    </tr>
    <tr>
	    <td>&nbsp;&nbsp;&nbsp;</td>  	
	    <td>: 
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="text" name="cc4" size="9" value="<%= AddUtil.parseDecimal(cc4) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'> cc 이상 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="da_amt3" size="11" value="<%= AddUtil.parseDecimal(da_amt3) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>원&nbsp;&nbsp;
		&nbsp;&nbsp;
		</td>
    </tr>
-->
  <% if ( auth_rw.equals("6") || auth_rw.equals("4") ) { %>    
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;6. 포상금액 적용효율</td>
      <td>:
       <input type="text" name="cam_per" size="3" value="<%= AddUtil.parseDecimal(cam_per) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
      % 반영.</td>
    </tr> 


 <% } %>  
<% } %>
</form>
</body>
</html>
