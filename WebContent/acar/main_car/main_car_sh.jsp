<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.car_office.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String base_dt = request.getParameter("base_dt")==null?"":request.getParameter("base_dt");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	
	CarOfficeDatabase co_db	= CarOfficeDatabase.getInstance();
	EstiJuyoDatabase ej_db = EstiJuyoDatabase.getInstance();
	
	
	
	
	Vector vt = ej_db.getReg_dtList();
	Vector vt2 = ej_db.getReg_dtListHp();
	
	//�ڵ���ȸ�� ����Ʈ
	CarCompBean cc_r [] = co_db.getCarCompAll_Esti();
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//��ȸ
	function search(){
		var fm = document.form1;
		fm.action = "main_car_sc.jsp";
		fm.target = "c_foot";
		fm.submit();
	}
	function EnterDown(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//���
	function esti_reg(){
		var fm = document.form1;
		fm.action = "main_car_add_20090901.jsp";
		fm.target = 'd_content';
		fm.submit();
	}	
	//��ü������
	function all_no(){
		var fm = document.form1;
		if(!confirm("�ش� �ֿ����� ���뿩�� ��������� �����Ͻðڽ��ϱ�?")) 	return;
		fm.action = "main_car_all_no.jsp";
		fm.target = 'nodisplay';
		fm.submit();
	}		
	//��ü Ȩ������ ����
	function all_hp(){
		var fm = document.form1;
		if(!confirm("���� �ֿ����� ���뿩�� ������ Ȩ�������� �����Ͻðڽ��ϱ�?")) 	return;
	//	var SUBWIN="sp_esti_reg_hp_upload.jsp";
		var SUBWIN="http://cms.amazoncar.co.kr:8080/acar/admin/sp_esti_reg_hp_upload.jsp";
		window.open(SUBWIN, "SP_JuyoEsti", "left=0, top=0, width=5, height=5, scrollbars=yes, status=yes, resizeable=yes");	
	}			
	//��ü����
	function all_esti(){
		var fm = document.form1;
		if(!confirm("�ش� �ֿ����� ���뿩�� �����Ͻðڽ��ϱ�?")) 	return;
		parent.c_foot.EstiList.main_car_upd_all_h();
	}			
	//��ü����
	function all_esti_r(){
		var fm = document.form1;
		if(!confirm("�ش� �ֿ����� ���뿩�� �����Ͻðڽ��ϱ�?")) 	return;
		parent.c_foot.EstiList.main_car_upd_all_h_r();
	}				
	//��ü����
	/* 201905 ��������Ÿ� 3���� �߰��� ��ü������ �������θ� ó��
	function all_esti_p(){
		var fm = document.form1;
		if(!confirm("�ش� �ֿ����� ���뿩�� �����Ͻðڽ��ϱ�?")) 	return;
		fm.action = "http://cms.amazoncar.co.kr:8080/acar/admin/sp_esti_reg_hp.jsp";
		fm.target = 'nodisplay';
		fm.submit();
	}
	*/
	
	
	//�α����� ����Ʈ
	function open_hotcar(){
		var fm = document.form1;
		var SUBWIN='./main_car_hotcar.jsp?auth_rw=<%=auth_rw%>&base_dt=<%=base_dt%>&car_comp_id=<%=car_comp_id%>&t_wd=<%=t_wd%>';
		window.open(SUBWIN, "OrderHotCar", "left=200, top=200, width=650, height=600, scrollbars=yes, status=yes");	
	}
	
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='base_dt' value='<%=base_dt%>'>
<table border=0 cellspacing=0 cellpadding=0 width=98%>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > <span class=style5>�ֿ���������</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr> 
        <td>
            <table border=0 cellpadding=0 cellspacing=1 width="100%">
                <tr> 
                    <td width=60%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                     
                      <img src=../images/center/arrow_jjs.gif align=absmiddle>&nbsp;
                      <select name="car_comp_id" >
                        <option value="" <%if(car_comp_id.equals(""))%>selected<%%>>-��ü-</option>                        
                        <%for(int i=0; i<cc_r.length; i++){
        						        cc_bean = cc_r[i];%>
                        <option value="<%= cc_bean.getCode() %>" <%if(car_comp_id.equals(cc_bean.getCode()))%>selected<%%>><%= cc_bean.getNm() %></option>
                        <%	}	%>
                        <option value="etc" <%if(car_comp_id.equals("etc"))%>selected<%%>>-������-</option>
                        
                      </select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        			  <img src=../images/center/arrow_cj.gif align=absmiddle>
        			  <input type="text" name="t_wd" value="<%=t_wd%>" size="20" class=text onKeyDown="javasript:EnterDown()">
                      &nbsp;<a href="javascript:search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="../images/center/button_search.gif" border="0" align="absmiddle"></a> 
                    </td>
                    <td align="right">
                        <%if(!auth_rw.equals("1")){%>
					  <a href="javascript:all_hp()" onMouseOver="window.status=''; return true" title='Ȩ����������'><img src="../images/center/button_hpage.gif" border="0" align="absmiddle"></a>&nbsp;&nbsp;					  
					  <!-- 201905 ��������Ÿ� 3���� �߰��� ��ü������ �������θ� ó��  &nbsp;&nbsp;<a href="javascript:all_esti_p();" title='�ϰ� ���ν��� ����'><img src=../images/center/button_p_allgj.gif border=0 align=absmiddle></a>-->					  
					  &nbsp;&nbsp;<a href="javascript:open_hotcar();" title='�α�����'><img src="../images/center/button_ppl.gif" border="0" align="absmiddle"></a>					  
			<%}%>		  
					</td>
                    <td align="right">
                        <%if(!auth_rw.equals("1")){%>
					  <a href="javascript:esti_reg()" onMouseOver="window.status=''; return true" title='���'><img src="../images/center/button_reg.gif" border="0" align="absmiddle"></a>&nbsp;&nbsp;&nbsp;
			<%}%>		  
	            </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>

