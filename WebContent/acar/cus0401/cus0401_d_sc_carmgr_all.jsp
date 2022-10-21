<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*" %>
<%@ page import="acar.cus0401.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");

	Cus0401_Database c_db = Cus0401_Database.getInstance();
 	//법인고객차량관리자
	Vector car_mgrs = c_db.getCarMgrAll(rent_mng_id, rent_l_cd);
	int mgr_size = car_mgrs.size();
		
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	//수정: 차량관리자 수정,추가
	function updCarmgr()
	{
		var fm = document.form1;
		fm.target='i_no';
		fm.action='./cus0401_d_sc_carmgr_all_u.jsp';
		fm.submit();
	}
//-->
</script>
</head>

<body>
<form name="form1" action="" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<table width=100% border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>거래업체담당자</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td align=right><a href="javascript:updCarmgr()"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a> 
        &nbsp;<a href="javascript:this.close()"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=20%>구분</td>
                    <td class=title width=26%>근무부서</td>
                    <td class=title width=19%>성명</td>
                    <td class=title width=19%>직위</td>
                    <td class=title width=16%>사용여부</td>
                </tr>
          <% 	if(mgr_size > 0){
		for(int i = 0 ; i < mgr_size ; i++){
			CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i); %>
                <tr> 
                    <td align='center' width=20%><input type='text' name='mgr_st' value='<%= mgr.getMgr_st()%>' readonly size='13' maxlength='15' class='white'  style='IME-MODE: active'></td>
                    <td align='center' width=26%><input type='text' name='mgr_dept' value='<%= mgr.getMgr_dept()%>' size='17' maxlength='15' class='white'  style='IME-MODE: active'></td>
                    <td align='center' width=19%><input type='text' name='mgr_nm' value='<%= mgr.getMgr_nm()%>' size='12' maxlength='20' class='white' style='IME-MODE: active'></td>
                    <td align='center' width=19%><input type='text' name='mgr_title' value='<%= mgr.getMgr_title()%>' size='12' maxlength='10' class='white' style='IME-MODE: active'></td>
                    <td align='center' width=16%><input type="checkbox" name="mgr_id" value="<%=mgr.getMgr_id()%>" <% if(mgr.getUse_yn().equals("1")){ %>checked<%}%>></td>
                </tr>
          <%
		}
	}
%>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
