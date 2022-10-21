<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.accid.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	String section 	= request.getParameter("section")==null?"":request.getParameter("section");
	String car_nm 	= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String deli_dt 	= request.getParameter("deli_dt")==null?"":request.getParameter("deli_dt");
	String ret_dt 	= request.getParameter("ret_dt")==null?"":request.getParameter("ret_dt");
	String ins_com 	= request.getParameter("ins_com")==null?"":request.getParameter("ins_com");
	
	String section_yn 	= request.getParameter("section_yn")==null?"N":request.getParameter("section_yn");
	
	//������ ������ ����Ʈ
	Vector rc_conts = rs_db.getResCarTaechaSearch("", "", section_yn, section);
	int rc_cont_size = rc_conts.size();
	
	//�ֱ� ������ û�� ���� ����Ʈ
	Vector vt = as_db.getResCarTaechaMyaccidSearch(deli_dt, ret_dt, ins_com);
	int vt_size = vt.size();
	
	System.out.println("[������û��]������ ������ ��ȸ");
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//�˻��ϱ�	
	function search(){
		var fm = document.form1;
		fm.action = "res_car_taecha_search.jsp";		
		fm.submit();	
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	function search_ok(car_no, car_nm){
		var fm = opener.document.form1;
		var p_fm = document.form1;
		
		<%	if(vt_size==1){%>
		if(p_fm.ins_car_no.value == car_no){
			if(!confirm('�̹� ����翡 ����û�� �� í���Դϴ�. �� �������� ���� �Ͻðڽ��ϱ�?')){
				return;
			}
		}		
		<%	}else{%>
		<%		for(int i = 0 ; i < vt_size ; i++){%> 
		if(p_fm.ins_car_no[<%=i%>].value == car_no){
			if(!confirm('�̹� ����翡 ����û�� �� í���Դϴ�. �� �������� ���� �Ͻðڽ��ϱ�?')){
				return;
			}
		}				
		<%		}%>				
		<%	}%>
		
		fm.ins_car_no.value = car_no;
		fm.ins_car_nm.value = car_nm;
		window.close();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='section' value='<%=section%>'>
<input type='hidden' name='car_nm' value='<%=car_nm%>'>
<input type='hidden' name='deli_dt' value='<%=deli_dt%>'>
<input type='hidden' name='ret_dt' value='<%=ret_dt%>'>
<input type='hidden' name='ins_com' value='<%=ins_com%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1><span class=style5>������ ������ ��ȸ</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>                   
                    <td width=270><input type='checkbox' name='section_yn' value="Y" <%if(section_yn.equals("Y"))%> checked<%%>> �������� 
					  &nbsp;&nbsp;
					  <a href='javascript:search()'><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>                  
                    </td>
                  
                </tr>
                </tr>
            </table>
        </td>
    </tr>	
	<tr><td class=h></td></tr>	
    <tr><td class=line2></td></tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=5%>����</td>
                    <td width=10% class='title'>��������</td>
                    <td width=10% class='title'>������ȣ</td>					
                    <td width=15% class='title'>����</td>         
                    <td width=10% class='title'>���ʵ����</td>         					
                    <td width=10% class='title'>���౸��</td>         					
                    <td width=20% class='title'>��ȣ</td>         										
                    <td width=10% class='title'>�����Ͻ�</td>         					
                    <td width=10% class='title'>���������Ͻ�</td>         															
                </tr>
          <%	for(int i = 0 ; i < rc_cont_size ; i++){
    					Hashtable reservs = (Hashtable)rc_conts.elementAt(i);%> 
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td><%=reservs.get("SECTION")%></td>										
                    <td><a href="javascript:search_ok('<%=reservs.get("CAR_NO")%>','<%=reservs.get("CAR_NM")%>')" onMouseOver="window.status=''; return true"><%=reservs.get("CAR_NO")%></a></td>
                    <td><%=reservs.get("CAR_NM")%></td>					
                    <td><%=reservs.get("INIT_REG_DT")%></td>
                    <td><%=reservs.get("RENT_ST_NM")%></td>					
                    <td><%=reservs.get("FIRM_NM")%></td>
                    <td><%=reservs.get("DELI_DT")%></td>					
                    <td><%=reservs.get("RET_DT")%></td>
                </tr>
          <%}%>		  		  
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr>
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� ����翡 ������ û���� �����Ʈ</span> </td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td rowspan='2' class='title' width=5%>����</td>					
                    <td colspan='2' class='title'>�������</td>										
                    <td rowspan='2' width=15% class='title'>��ȣ</td>         													
                    <td rowspan='2' width=10% class='title'>�����</td>         					
                    <td colspan='2' width=20% class='title'>��������</td>         																							
                    <td rowspan='2' width=20% class='title'>�����Ⱓ</td>         					
                    <td rowspan='2' width=10% class='title'>û������</td>         															
                </tr>
                <tr> 
                    <td width=10% class='title'>������ȣ</td>										
                    <td width=10% class='title'>����</td>         													
                    <td width=10% class='title'>������ȣ</td>										
                    <td width=10% class='title'>����</td>         													
                </tr>
          <%	for(int i = 0 ; i < vt_size ; i++){
    					Hashtable ht = (Hashtable)vt.elementAt(i);%> 
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td><%=ht.get("A_CAR_NO")%></td>										
                    <td><%=ht.get("A_CAR_NM")%></td>															
                    <td><%=ht.get("FIRM_NM")%></td>
                    <td><%=ht.get("INS_COM")%></td>					
                    <td><%=ht.get("CAR_NO")%><input type='hidden' name='ins_car_no' value='<%=ht.get("CAR_NO")%>'></td>
                    <td><%=ht.get("CAR_NM")%></td>					
                    <td><%=ht.get("USE_ST")%>~<%=ht.get("USE_ET")%></td>					
                    <td><%=ht.get("REQ_DT")%></td>
                </tr>
          <%}%>		  		  
            </table>
        </td>
    </tr>	
    <tr> 
        <td align="right"><a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
