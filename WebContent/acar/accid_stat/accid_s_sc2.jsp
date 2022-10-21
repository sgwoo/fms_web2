<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function AccidentDisp(m_id, l_cd, c_id, accid_id, accid_st){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.accid_id.value = accid_id;		
		fm.accid_st.value = accid_st;				
		fm.cmd.value = "u";		
		fm.submit();
	}
	
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=720, height=550, scrollbars=yes");
	}
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"0":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	int size1 = 0;
	
	if(!st_dt.equals("")) 	st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) 	end_dt = AddUtil.replace(end_dt, "-", "");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
%>
<form name='form1' action='../accid_mng/accid_u_frame.jsp' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='accid_id' value=''>
<input type='hidden' name='accid_st' value=''>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='go_url' value='../accid_stat/accid_s_frame.jsp'>
<table border="0" cellspacing="0" cellpadding="0" width=98%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� ������ ��Ȳ</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width='14%'>��</td>
                    <td class='title' width='6%'>1��</td>
                    <td class='title' width="6%">2��</td>
                    <td class='title' width="6%">3��</td>
                    <td class='title' width="6%">4��</td>
                    <td class='title' width="6%">5��</td>
                    <td class='title' width="6%">6��</td>
                    <td class='title' width="6%">7��</td>
                    <td class='title' width="6%">8��</td>
                    <td class='title' width="6%">9��</td>
                    <td class='title' width="6%">10��</td>
                    <td class='title' width="6%">11��</td>
                    <td class='title' width=6%>12��</td>
                    <td class='title' width="14%">��</td>
                </tr>
                <tr> 
                    <td class='title'>�Ǽ�</td>
                    <%	Hashtable accid4 = as_db.getAccidStat04(br_id, gubun1, gubun2, gubun3, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc);%>
                    <td align="center"><%=accid4.get("SU1")%>��</td>
                    <td align="center"><%=accid4.get("SU2")%>��</td>
                    <td align="center"><%=accid4.get("SU3")%>��</td>
                    <td align="center"><%=accid4.get("SU4")%>��</td>
                    <td align="center"><%=accid4.get("SU5")%>��</td>
                    <td align="center"><%=accid4.get("SU6")%>��</td>
                    <td align="center"><%=accid4.get("SU7")%>��</td>
                    <td align="center"><%=accid4.get("SU8")%>��</td>
                    <td align="center"><%=accid4.get("SU9")%>��</td>
                    <td align="center"><%=accid4.get("SU10")%>��</td>
                    <td align="center"><%=accid4.get("SU11")%>��</td>
                    <td align="center"><%=accid4.get("SU12")%>��</td>
                    <td align="center"><%=accid4.get("TOT_SU")%>��</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���Ϻ� ������ ��Ȳ</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tR>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width='14%'>����</td>
                    <td class='title' width='10%'>��</td>
                    <td class='title' width="10%">ȭ</td>
                    <td class='title' width="10%">��</td>
                    <td class='title' width="10%">��</td>
                    <td class='title' width="10%">��</td>
                    <td class='title' width="10%">��</td>
                    <td class='title' width="10%">��</td>
                    <td class='title' width="16%">��</td>
                </tr>
                <tr> 
                    <td class='title'>�Ǽ�</td>
                    <%	Hashtable accid5 = as_db.getAccidStat05(br_id, gubun1, gubun2, gubun3, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc);%>
                    <td align="center"><%=accid5.get("SU1")%>��</td>
                    <td align="center"><%=accid5.get("SU2")%>��</td>
                    <td align="center"><%=accid5.get("SU3")%>��</td>
                    <td align="center"><%=accid5.get("SU4")%>��</td>
                    <td align="center"><%=accid5.get("SU5")%>��</td>
                    <td align="center"><%=accid5.get("SU6")%>��</td>
                    <td align="center"><%=accid5.get("SU7")%>��</td>
                    <td align="center"><%=accid5.get("TOT_SU")%>��</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
</table>
</form>
</body>
</html>
