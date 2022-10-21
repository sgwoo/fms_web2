<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String st 	= request.getParameter("st")==null?"":request.getParameter("st");
	String st_nm 	= request.getParameter("st_nm")==null?"":request.getParameter("st_nm");
	String s_dt 	= request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String s_br 	= request.getParameter("s_br")==null?"":request.getParameter("s_br");
	
	
	Vector vt = rs_db.getRmRentStat1SubList(mode, st, s_dt, s_br);
	int vt_size = vt.size();
%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
 	//��༭ ���� ����
	function view_cont(rent_mng_id, rent_l_cd){
	
		var fm = document.form1;
		
		fm.c_st.value = 'fee_rm';
		fm.rent_mng_id.value = rent_mng_id;
		fm.rent_l_cd.value = rent_l_cd;
				
		fm.action = '/fms2/lc_rent/lc_c_frame.jsp';
		fm.target = 'd_content';
		fm.submit();
	}
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
 <input type='hidden' name='c_st' value=''>
 <input type='hidden' name='rent_mng_id' value=''>
 <input type='hidden' name='rent_l_cd' value=''>
 <table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ý��� > ����Ʈ���� > <span class=style5>���Ͽ�����Ȳ <%=st_nm%> ���θ���Ʈ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=5% class=title>����</td>
                    <td width=20% class=title>��ȣ</td>
                    <td width=10% class=title>������ȣ</td>
                    <td width=20% class=title>����</td>
                    <td width=10% class=title>�������</td>
                    <td width=10% class=title>�뿩������</td>
                    <td width=10% class=title>�뿩������</td>
                    <td width=10% class=title>��������</td>                                        
                    <td width=5% class=title>����</td>
                </tr>
                <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
                %>	            
                <tr> 
                    <td align='center'><%=i+1%></td>                    
                    <td align='center'><%=ht.get("FIRM_NM")%></td>
                    <td align='center'><%=ht.get("CAR_NO")%></td>
                    <td align='center'><%=ht.get("CAR_NM")%></td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("RENT_START_DT")))%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("RENT_END_DT")))%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("CLS_DT")))%></td>
                    <td align='center'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true">����</a></td>
                </tr>    				                                    				
		<%	}%>                																																	
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>