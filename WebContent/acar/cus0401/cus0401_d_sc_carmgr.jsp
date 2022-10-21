<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.cont.*, acar.res_search.*" %>
<jsp:useBean id="rs_db" 	class="acar.res_search.ResSearchDatabase" 	scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_way = request.getParameter("rent_way")==null?"":request.getParameter("rent_way");
//System.out.println("rmid="+rent_mng_id+" rlcd="+rent_l_cd);	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//�������� ��������
	Hashtable reserv = rs_db.getResCarCase(car_mng_id, "2");
	String use_st = String.valueOf(reserv.get("USE_ST"))==null?"":String.valueOf(reserv.get("USE_ST"));
		
	Hashtable reserv2 = rs_db.getResCarCase(car_mng_id, "1");
	String use_st2 = String.valueOf(reserv2.get("USE_ST"))==null?"":String.valueOf(reserv2.get("USE_ST"));
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
function carmgrAll(){
	var fm = document.form1;
	window.open('/acar/cus0401/cus0401_d_sc_carmgr_all.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%= car_mng_id %>&rent_mng_id=<%= rent_mng_id %>&rent_l_cd=<%= rent_l_cd %>', "MGR_ALL", "left=100, top=100, width=540, height=300, scrollbars=yes");
}
	//������� ����
	function view_client()
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>&r_st=1", "VIEW_CLIENT", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}	
	
	//�����̷�
	function view_sh_res_h(){
		var SUBWIN="/acar/secondhand/reserveCarHistory.jsp?car_mng_id=<%=car_mng_id%>";
		window.open(SUBWIN, "reserveCarHistory", "left=50, top=50, width=850, height=800, scrollbars=yes, status=yes");
	}		
//-->
</script>
</head>

<body>
<table width="100%" border="0" cellspacing="1" cellpadding="0">
    <tr> 
        <td width="100%">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><a href="javascript:view_client()" onMouseOver="window.status=''; return true" title='���󼼳����� �˾��մϴ�.'><%= c_db.getNameById(c_db.getClinet_id(rent_mng_id, rent_l_cd),"CLIENT") %>
					<%if(rent_way.equals("1")) {%>�Ϲݽ�
					<%}else{%>�⺻��
					<%}%>
					</a> 										
					&nbsp;�����</span>
					&nbsp;
					<%if(!use_st.equals("null")){%>
                              ( [����] <%=reserv.get("RENT_ST")%> &nbsp;<%=reserv.get("FIRM_NM")%> &nbsp;<a href="javascript:view_sh_res_h()" title="�̷�"><img src=/acar/images/center/button_ir_ss.gif align=absmiddle border=0></a> )
                              <%}else{ %>
                              <%	if(!use_st2.equals("null")){%>
                              ( [����] <%=reserv2.get("RENT_ST")%> &nbsp;<%=reserv2.get("FIRM_NM")%> &nbsp;<a href="javascript:view_sh_res_h()" title="�̷�"><img src=/acar/images/center/button_ir_ss.gif align=absmiddle border=0></a> )
                              <%	} %>
                              <%} %>
					</td>
                    <td><div align="right"> 
                      <a href="javascript:carmgrAll();" value="��ü����"><img src="/acar/images/center/button_see_all.gif" align="absmiddle" border="0"></a>
                    </div></td>
                </tr>
            </table>
         </td>
    </tr>
    <tr> 
        <td ><iframe src="./cus0401_d_sc_carmgr_in.jsp?auth_rw=<%= auth_rw %>&car_mng_id=<%= car_mng_id %>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>" name="inner_carmgr" width="100%" height="120" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0" scrolling="yes"></iframe></td>
    </tr>
</table>
</body>
</html>
