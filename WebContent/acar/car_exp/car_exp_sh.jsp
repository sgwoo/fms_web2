<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		if(fm.st_dt.value != ''){ fm.st_dt.value = ChangeDate3(fm.st_dt.value);	}
		if(fm.end_dt.value != ''){ fm.end_dt.value = ChangeDate3(fm.end_dt.value);	}
		if(fm.st_dt.value !='' && fm.end_dt.value==''){ fm.end_dt.value = fm.st_dt.value; }		
		fm.submit()
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
		
	//���÷��� Ÿ��(�˻�) -�˻����� ���ý�
	function cng_input(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8'){ //���������
			td_input.style.display	= 'none';
			td_bus.style.display	= '';
			td_brch.style.display	= 'none';			
		}else if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '6'){ //������
			td_input.style.display	= 'none';
			td_bus.style.display	= 'none';			
			td_brch.style.display	= '';						
		}else{
			td_input.style.display	= '';
			td_bus.style.display	= 'none';
			td_brch.style.display	= 'none';						
		}
	}	
	//���÷��� Ÿ��(�˻�)-������ȸ ���ý�
	function cng_input1(){
		var fm = document.form1;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '4'){ //�Ⱓ
			td_dt.style.display	 = '';
		}else{
			if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '5'){ //�˻�
				fm.gubun3.options[0].selected = true;
			}				
			td_dt.style.display	 = 'none';
		}
	}		
	
	//���� ������ ����Ʈ �̵�
	function list_move()
	{
		var fm = document.form1;
		var url = "";
		fm.auth_rw.value = "";		
		fm.gubun4.value = "";		
		var idx = fm.gubun1.options[fm.gubun1.selectedIndex].value;
		if(idx == '1') 		url = "/fms2/con_fee/fee_frame_s.jsp";
		else if(idx == '2') url = "/fms2/con_grt/grt_frame_s.jsp";
		else if(idx == '3') url = "/acar/con_forfeit/forfeit_frame_s.jsp";
		else if(idx == '4') url = "/fms2/con_ins_m/ins_m_frame_s.jsp";
		else if(idx == '5') url = "/acar/con_ins_h/ins_h_frame_s.jsp";
		else if(idx == '6') url = "/fms2/con_cls/cls_frame_s.jsp";		
		else if(idx == '7') url = "/acar/settle_acc/settle_s_frame.jsp";	
		else if(idx == '8') url = "/acar/con_debt/debt_frame_s.jsp";
		else if(idx == '9') url = "/acar/con_ins/ins_frame_s.jsp?f_list=now";
		else if(idx == '10') url = "/acar/forfeit_mng/forfeit_s_frame.jsp";
		else if(idx == '11') url = "/acar/commi_mng/commi_frame_s.jsp";
		else if(idx == '12') url = "/acar/mng_exp/exp_frame_s.jsp";			
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();								
	}				
//-->
</script>
</head>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"12":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"2":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	
	
	
%>
<form name='form1' action='car_exp_sc.jsp' target='c_body' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='f_list' value=''>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ��� > <span class=style5>ȯ���ڵ�����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<tr>
		<td>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='205'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jhgb.gif align=absmiddle>&nbsp;
                      <select name="gubun1" onChange="javascript:list_move()">
                        <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>�뿩��</option>
                        <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>������</option>
                        <option value="3" <%if(gubun1.equals("3")){%>selected<%}%>>���·�(��)</option>
                        <option value="4" <%if(gubun1.equals("4")){%>selected<%}%>>��å��</option>
                        <option value="5" <%if(gubun1.equals("5")){%>selected<%}%>>��/������</option>
                        <option value="14" <%if(gubun1.equals("14")){%>selected<%}%>>ȯ�޺����</option>
                        <option value="15" <%if(gubun1.equals("15")){%>selected<%}%>>ȯ���ڵ�����</option>
                        <option value="6" <%if(gubun1.equals("6")){%>selected<%}%>>��������</option>
                        <option value="7" <%if(gubun1.equals("7")){%>selected<%}%>>�̼�������</option>
                        <option value="8" <%if(gubun1.equals("8")){%>selected<%}%>>�Һα�</option>
                        <option value="9" <%if(gubun1.equals("9")){%>selected<%}%>>�����</option>
                        <option value="10" <%if(gubun1.equals("10")){%>selected<%}%>>���·�(��)</option>
                        <option value="11" <%if(gubun1.equals("11")){%>selected<%}%>>���޼�����</option>																
                        <option value="12" <%if(gubun1.equals("12")){%>selected<%}%>>��Ÿ���</option>																				
                        <option value="13" <%if(gubun1.equals("13")){%>selected<%}%>>Ư�Ҽ�</option>																								
                      </select>
                    </td>
                    <td width='130'><img src=/acar/images/center/arrow_ssjh.gif align=absmiddle>&nbsp;
                      <select name="gubun2" onChange="javascript:cng_input1()">
        <!--			  
                        <option value="1" <%if(gubun2.equals("1")){%>selected<%}%>>���</option>
                        <option value="2" <%if(gubun2.equals("2")){%>selected<%}%>>����</option>
                        <option value="6" <%if(gubun2.equals("6")){%>selected<%}%>>����+��ü</option>				
                        <option value="3" <%if(gubun2.equals("3")){%>selected<%}%>>��ü</option>-->				
                        <option value="4" <%if(gubun2.equals("4")){%>selected<%}%>>�Ⱓ</option>
        <!--            <option value="5" <%if(gubun2.equals("5")){%>selected<%}%>>�˻�</option>-->
                      </select>
                    </td>
                    <td width='185'><img src=/acar/images/center/arrow_sbjh.gif align=absmiddle>&nbsp;
                      <select name="gubun3">
                        <option value="1" <%if(gubun3.equals("1")){%>selected<%}%>>��ü</option>
                        <option value="2" <%if(gubun3.equals("2")){%>selected<%}%>>����</option>
                        <option value="3" <%if(gubun3.equals("3")){%>selected<%}%>>�̼���</option>
                      </select>
                    </td>
                    <td align="left" width="168"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td id='td_dt' <%if(gubun2.equals("4")){%>style="display:''"<%}else{%>style='display:none'<%}%>> 
                                    <input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                                    ~ 
                                    <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td width=405><img src=/acar/images/center/arrow_hgsy.gif align=absmiddle>&nbsp;
                        <select name="gubun4">			  
                            <option value="" <%if(gubun4.equals("")){%>selected<%}%>>��ü</option>
                            <option value='1' <%if(gubun4.equals("1")){%> selected <%}%>>�뵵����</option>
                            <option value='2' <%if(gubun4.equals("2")){%> selected <%}%>>�Ű�</option>
                        </select>
                    </td>
                </tr>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
                        <select name='s_kd'>
                            <option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>������ȣ</option>
                            <option value='5' <%if(s_kd.equals("5")){%> selected <%}%>>����</option>				
                        </select>
                    </td>
                    <td> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td> 
                                    <input type='text' name='t_wd' size='16' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()'>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td><img src=/acar/images/center/arrow_jrjg.gif align=absmiddle>&nbsp;
                        <select name='sort_gubun' onChange='javascript:search()'>
                            <option value='1' <%if(sort_gubun.equals("1")){%> selected <%}%>>ȯ�޻����߻�����</option>
                            <option value='2' <%if(sort_gubun.equals("2")){%> selected <%}%>>ȯ������</option>
                            <option value='3' <%if(sort_gubun.equals("3")){%> selected <%}%>>������ȣ</option>
                            <option value='4' <%if(sort_gubun.equals("4")){%> selected <%}%>>ȯ�޻���</option>
                            <option value='5' <%if(sort_gubun.equals("5")){%> selected <%}%>>ȯ�ޱݾ�</option>
                            <option value='6' <%if(sort_gubun.equals("6")){%> selected <%}%>>ȯ�޿����ݾ�</option>							
                        </select>
                    </td>
                    <td> 
                        <input type='radio' name='asc' value='0' checked onClick='javascript:search()'>
                        �������� 
                        <input type='radio' name='asc' value='1' onClick='javascript:search()'>
                        �������� </td>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:search()'><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
					&nbsp;&nbsp;&nbsp;<a href="/acar/excel_reg/excel.jsp?action=exp_rtn_doc_rec.jsp" target="_blank"><img src=/acar/images/center/button_excel.gif border=0 align=absmiddle></a>
                    </td>
                </tr>
            </table>
        </td>
	</tr>
</table>
</form>
</body>
</html>