<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.settle_acc.*" %>
<jsp:useBean id="st_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String brch 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String loan_st 	= request.getParameter("loan_st")	==null?"":request.getParameter("loan_st");
	String save_dt 	= request.getParameter("save_dt")	==null?"":request.getParameter("save_dt");	
	String max_amt 	= request.getParameter("max_amt")	==null?"":request.getParameter("max_amt");
	
	
	//채권캠페인 노력상리스트
	Vector vt = st_db.getStatSettleEffIn(loan_st, save_dt, max_amt);
	int vt_size = vt.size();	
	
	float avg_r_fee_per 	= 0.0f;
	
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body leftmargin="15">
<form action="" name="form1" method="POST">
<table border=0 cellspacing=0 cellpadding=0 width="550">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 캠페인관리 > 채권캠페인 > <span class=style5>채권캠페인 <%=loan_st%>군 내근직 포상</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>                    
            <table border="0" cellspacing="1" cellpadding="0" width="550">
                <tr> 
                    <td width="50" class=title>담당자</td>
                    <td width="50" class=title>파트너</td>
                    <td width="90" class=title>평균감소치</td>
                    <td width="90" class=title>당일감소치</td>
                    <td width="90" class=title>적용감소치</td>  
            <!--        <td width="90" class=title>캠페인적용</td>            -->        
                    <td width="90" class=title>내근포상금액</td>
                </tr>
                <%for (int i = 0 ; i < vt_size ; i++){
    			Hashtable ht = (Hashtable)vt.elementAt(i);
    			    		
    			avg_r_fee_per = avg_r_fee_per+ AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht.get("R_EFF_PER")),3));	
    			
    		%>
                <tr> 
                    <td align='center'><%=ht.get("USER_NM")%></td>
                    <td align='center'><%=ht.get("PARTNER_NM")%></td>
                    <td align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("EFF_PER1")),3)%></td>
                    <td align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("EFF_PER2")),3)%></td>
        <!--            <td align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("RC_EFF_PER")),3)%></td>                    -->
                    <td align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("R_EFF_PER")),3)%></td>                    
                    <td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AMT_IN")))%></td>
                </tr>    			
	  	<%}%>
	  
            </table>
        </td>
    </tr>
    <tr>    	
        <td align="right"><a href="javascript:self.close();"><img src=../images/center/button_close.gif border=0></a></td>
    </tr>	
    <tr>    	
        <td>* 평균감소치 : 당일을 제외한 캠페인 기간동안의 연체감소치 평균</td>
    </tr>    	
    <tr>    	
        <td>* 당일감소치 : 당일 연체감소치</td>
    </tr>	
    <tr>    	
        <td>* 적용감소치 : 평균감소치 80% + 당일감소치 20% </td>
    </tr>
   <!-- 	
      <tr>    	
        <td>* 캠페인적용 : +/ - 각각 적용감소치의 평균을 초과하는 경우 평균+ 초과분 5%  적용 </td>
    </tr>

     <tr>    	
        <td>* 파트너포상대상 : 적용감소치 평균의 60% 보다 큰 경우</td>
    </tr>	
    -->
     <tr>    	
        <td>* 파트너포상대상 : 총인원의 60%</td>
    </tr>	
     <tr>    	
        <td>* 파트너포상금액 : 내근직포상총금액을 연체율감소치분에 따라 계산 (최소금액 50,000)</td>
    </tr>	
     

</table>
</form>
</body>
</html>
