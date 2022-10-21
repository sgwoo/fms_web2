<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*"%>
<jsp:useBean id="st_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String bus_id2 = request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	String loan_st = request.getParameter("loan_st")==null?"":request.getParameter("loan_st");
	
	float dly_per1 = 0;
	float dly_per2 = 0;
	String per2 = "";
	int cnt = 0;
	
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//계산식 변수
	String var3 = e_db.getEstiSikVarCase(loan_st, "", "dly"+loan_st+"_bus3");
	String var4 = e_db.getEstiSikVarCase(loan_st, "", "dly"+loan_st+"_bus4");
	String var5 = e_db.getEstiSikVarCase(loan_st, "", "dly"+loan_st+"_bus5");
	String var6 = e_db.getEstiSikVarCase(loan_st, "", "dly"+loan_st+"_bus6");
	String var7 = e_db.getEstiSikVarCase(loan_st, "", "dly"+loan_st+"_bus7");
	
	//사원별미수금현황리스트
	Vector vt = st_db.getStatSettleAvgPerList(bus_id2, save_dt, var3, var6);
	int vt_size = vt.size();
	
	float sum_per = 0.0f, avg_per = 0.0f;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
		
//-->
</script>
</head>
<body>

<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='bus_id2' value='<%=bus_id2%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='loan_st' value='<%=loan_st%>'>
<input type='hidden' name='var3' value='<%=var3%>'>
<input type='hidden' name='var6' value='<%=var6%>'>
<input type='hidden' name='size' value='<%=vt_size%>'>
<table width="700" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 캠페인관리 > 채권관리캠페인 (<%=loan_st%>군) > <span class=style5>평균연체율</span></span></td>
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
        <td class="line">              
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=100 class="title">기준일자</TD>
                    <td width=130 class="title">총받을어음</TD>
                    <td width=70 class="title">연체건수</TD>
                    <td width=130 class="title">연체금액</TD>					
                    <td width=100 class="title">마감연체율</TD>					
                    <td width=170 class="title">마감일시</TD>					
				</tr>	
				<%if(vt_size > 0){
						for (int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							sum_per 	= sum_per + AddUtil.parseFloat((String)ht.get("PER1"));
							%>
                <tr> 
                    <td align='center'><%=ht.get("SAVE_DT")%></TD>
                    <td align='right'><%=Util.parseDecimalLong(String.valueOf(ht.get("TOT_AMT")))%></TD>
                    <td align='center'><%=ht.get("SU")%></TD>					
                    <td align='right'><%=Util.parseDecimalLong(String.valueOf(ht.get("AMT")))%></TD>
                    <td align='right'><%=ht.get("PER1")%></TD>
                    <td align='center'><%=ht.get("REG_DT")%></TD>
				</tr>	
				<%		}%>		
                <tr> 
                    <td class="title" colspan='4'>평균</TD>
                    <td align='right'><%=AddUtil.parseFloatCipher(sum_per/vt_size,3)%></TD>
                    <td align='center'>&nbsp;</TD>
				</tr>							
				<%	}%>
            </table>
		</td>
    </tr>
</table>
</form>  
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
