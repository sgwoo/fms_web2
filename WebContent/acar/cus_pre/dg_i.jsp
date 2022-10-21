<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.car_register.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String dg_dt = request.getParameter("dg_dt")==null?"":request.getParameter("dg_dt");
	String dg_no = request.getParameter("dg_no")==null?"":request.getParameter("dg_no");
	String dg_yn = request.getParameter("dg_yn")==null?"":request.getParameter("dg_yn");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	AddCarRegDatabase cr_db = AddCarRegDatabase.getInstance();
	
	Hashtable ht = cr_db.dg_list(car_mng_id);
	
	dg_dt = Util.getDate();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<title>차령연장 우편접수 등기입력</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
function reg(){
	var fm = document.form1;
	
	fm.cmd.value = "i";	
	fm.target="i_no";
	fm.action="dg_a.jsp";		
	fm.submit();
}

function ChangeDT()
{
	var theForm = document.form1;
	theForm.dg_dt.value = ChangeDate(theForm.dg_dt.value);
}

//-->
</script>
</head>

<body>
<form name='form1'  method='post'>
<input type="hidden" name="user_id" value="<%=user_id%>"> 
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">	
<input type="hidden" name="cmd" value="">	
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr> 
        <td colspan=100>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;차량번호 : <%=ht.get("CAR_NO")%>    <span class=style1><span class=style5>&nbsp;&nbsp;&nbsp;&nbsp;차령연장 우편접수 등기번호 입력</span> </span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<TR>
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
				<tr>
					<td class=title width="20%">등기번호</td>
					<td width="30%">&nbsp;<input type='text' name="dg_no" value='<%if(!ht.get("DG_NO").equals("")){%><%=ht.get("DG_NO")%><%}%>' size='30' class='text' ></td>
					<td class=title width="10%">등록일자</td>
					<td width="15%">&nbsp;<input type='text' name="dg_dt" value='<%if(!ht.get("DG_DT").equals("")){%><%=AddUtil.ChangeDate2((String)ht.get("DG_DT"))%><%}else{%><%=dg_dt%><%}%>' size='15' class='text' ></td>
					<td class=title width="10%">결과</td>
					<td width="15%">&nbsp;<SELECT NAME="dg_yn">
								<OPTION VALUE="N" <%if(ht.get("DG_YN").equals("N")){%>SELECTED<%}%>>처리중
								<OPTION VALUE="Y" <%if(ht.get("DG_YN").equals("Y")){%>SELECTED<%}%>>처리완료
							</SELECT>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr> 
        <td class=h align="right">  </td>
	<tr> 
        <td class=h align="right">
        	<a href="javascript:reg()"><img src="/acar/images/center/button_reg.gif" border="0" align="absmiddle"></a>
			<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif" border="0" align="absmiddle"></a>        	
        	</td>
    </tr>
</table>

</body>
</html>
