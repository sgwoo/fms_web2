<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.bank_mng.*, acar.cls.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String mort_st = request.getParameter("mort_st")==null?"":request.getParameter("mort_st");
	String mort_dt = request.getParameter("mort_dt")==null?"":request.getParameter("mort_dt");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int seq_no = request.getParameter("seq_no")==null?0:Util.parseInt(request.getParameter("seq_no"));
	int count = 0;
	

	Vector cltrs = abl_db.getCltr_list2(car_mng_id);
	int cltr_size = cltrs.size();
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body leftmargin="15">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>저당권</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td width=5% class=title>연번</td>
                    <td width=19% class=title>저당권자</td>
                    <td width=19% class=title>채권가액</td>
                    <td width=12% class=title>대출일자</td>
                    <td width=12% class=title>설정일자</td>
                    <td width=12% class=title>말소일자</td>
                    <td width=21% class=title>말소사유</td>
                </tr>
                <%	if(cltr_size > 0){
        				for(int i = 0 ; i < cltr_size ; i++){
        					Hashtable cltr = (Hashtable)cltrs.elementAt(i);%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=cltr.get("CLTR_USER")%></td>
                    <td align="center"><%=Util.parseDecimal(String.valueOf(cltr.get("CLTR_AMT")))%>원</td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(cltr.get("LEND_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(cltr.get("CLTR_SET_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(cltr.get("CLTR_EXP_DT")))%></td>
                    <td align="center"><%=cltr.get("CLTR_EXP_CAU")%></td>
                </tr>
                <%		}
        			}else{%>
                <tr> 
                    <td colspan=7 align=center>등록된 데이타가 없습니다.</td>
                </tr>
                <%	}%>
            </table>
        </td>
    </tr>
</table>
</body>
</html>