<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	ConditionDatabase cdb = ConditionDatabase.getInstance();
	String gubun = "0";
	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	String auth_rw = "";
	String br_id = "";
	String dt = "2";
	
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("gubun") != null)	gubun = request.getParameter("gubun");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	if(request.getParameter("br_id") != null)	br_id = request.getParameter("br_id");
	
	String ccst [] = cdb.getClsCondSta2_new(dt,ref_dt1,ref_dt2, gubun2);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-170;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
//리스트 엑셀 전환
function pop_excel(){
	var fm = document.form1;
	fm.target = "_blank";
	
	fm.action = "popup_cls_cond_excel.jsp";
	fm.submit();
}		
//-->
</script>
</head>
<body leftmargin=15 rightmargin=0>
<form name='form1' method='post'>
<input type='hidden' name='ref_dt1' value='<%=ref_dt1%>'>
<input type='hidden' name='ref_dt2' value='<%=ref_dt2%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>  
<input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
<input type='hidden' name='dt' value='<%=dt%>'>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
     <tr>	
	  <td align='left'><a href="javascript:pop_excel()"><img src="/acar/images/center/button_excel.gif" align="absmiddle" border="0"></a>
	  </td>
	</tr>
	
    <tr>
		<td>
			 <table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td colspan=2><iframe src="./cls_cond_sc_in.jsp?gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&br_id=<%=br_id%>" name="ClsCondList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>							
	
			</table>
		</td>
	</tr>
	<tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td width=10% class=title style='height:38'>구분</td>
                    <td width=9% class=title>출고전해지<br>(신차)</td>
                    <td width=9% class=title>개시전해지<br>(재리스)</td>
                    <td width=9% class=title>차종변경</td>
                    <td width=9% class=title>영업소변경</td>
                    <td width=9% class=title>계약승계</td>
                    <td width=9% class=title>중도해지</td>
                    <td width=9% class=title>계약만료</td>
                    <td width=9% class=title>매각</td>
                    <td width=9% class=title>매입옵션</td>
                    <td width=9% class=title>폐차</td>
                </tr>
                <tr> 
                    <td class=title>건수</td>
                    <td align="right"><%=ccst[6]%> 건 &nbsp;</td>
                    <td align="right"><%=ccst[9]%> 건 &nbsp;</td>
                    <td align="right"><%=ccst[3]%> 건 &nbsp;</td>
                    <td align="right"><%=ccst[2]%> 건 &nbsp;</td>
                    <td align="right"><%=ccst[4]%> 건 &nbsp;</td>
                    <td align="right"><%=ccst[1]%> 건 &nbsp;</td>
                    <td align="right"><%=ccst[0]%> 건</td>
                    <td align="right"><%=ccst[5]%> 건</td>
                    <td align="right"><%=ccst[7]%> 건</td>
                    <td align="right"><%=ccst[8]%> 건</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>