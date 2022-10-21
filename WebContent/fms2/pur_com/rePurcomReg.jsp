<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*, acar.cont.*,acar.client.*, acar.user_mng.*" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 			= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 				= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 			= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String com_con_no 	= request.getParameter("com_con_no")==null?"":request.getParameter("com_con_no");
	String o_rent_mng_id= request.getParameter("o_rent_mng_id")==null?"":request.getParameter("o_rent_mng_id");
	String o_rent_l_cd 	= request.getParameter("o_rent_l_cd")==null?"":request.getParameter("o_rent_l_cd");	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 		= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");	
	String seq 					= request.getParameter("seq")==null?"":request.getParameter("seq");
	String from_page 		= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	//��������
	CarPurDocListBean cpd_bean = cod.getCarPurCom(o_rent_mng_id, o_rent_l_cd, com_con_no);
	
	//�����������
	CarOffBean co_bean = cod.getCarOffBean(cpd_bean.getCar_off_id());
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	UsersBean dlv_mng_bean 	= umd.getUsersBean(cpd_bean.getDlv_mng_id());
		
	UsersBean udt_mng_bean_s 	= umd.getUsersBean(nm_db.getWorkAuthUser("�������������"));
	UsersBean udt_mng_bean_b2 = umd.getUsersBean(nm_db.getWorkAuthUser("�λ����������"));
	UsersBean udt_mng_bean_b 	= umd.getUsersBean(nm_db.getWorkAuthUser("�λ�������"));
	UsersBean udt_mng_bean_d 	= umd.getUsersBean(nm_db.getWorkAuthUser("����������"));			
	UsersBean udt_mng_bean_g 	= umd.getUsersBean(nm_db.getWorkAuthUser("�뱸������"));
	UsersBean udt_mng_bean_j 	= umd.getUsersBean(nm_db.getWorkAuthUser("����������"));

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript">
<!--
	//��� ����	
	function search_cont(){
		var fm = document.form1;
		fm.action = "search_cont.jsp";
		window.open("about:blank", "S_CONT", "left=350, top=50, width=1050, height=700, scrollbars=yes, status=yes");
		fm.target = "S_CONT";
		fm.submit();
	}

	//�μ����� ����� ����Ʈ
	function setOff(){
		var fm = document.form1;
		
		var deposit_len = fm.udt_firm.length;			
		for(var i = 1 ; i < deposit_len ; i++){
			fm.udt_firm.options[i] = null;			
		}
		
		if(fm.udt_st.value == '1'){
			fm.udt_firm.options[1] = new Option('������ ����������', '������ ����������');					
			fm.udt_firm.value = '������ ����������';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '2'){
			<%if(AddUtil.getDate2(4) >= 20210205){%>
			fm.udt_firm.options[1] = new Option('������TS', '������TS');
			fm.udt_firm.options[2] = new Option('�����̵���ǽ��� ����1�� ������', '�����̵���ǽ��� ����1�� ������');
			fm.udt_firm.options[3] = new Option('����ī(������)', '����ī(������)');
			fm.udt_firm.value = '������TS';
			<%}else{%>
			fm.udt_firm.options[1] = new Option('������������� ������', '������������� ������');
			fm.udt_firm.options[2] = new Option('�����̵���ǽ��� ����1�� ������', '�����̵���ǽ��� ����1�� ������');
			fm.udt_firm.options[3] = new Option('����ī(������)', '����ī(������)');
			fm.udt_firm.options[4] = new Option('������TS', '������TS');
			fm.udt_firm.value = '������������� ������';
			<%}%>
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '3'){
			fm.udt_firm.options[1] = new Option('�̼���ũ', '�̼���ũ');								
			fm.udt_firm.value = '�̼���ũ';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '5'){
			fm.udt_firm.options[1] = new Option('�뱸 ������', '�뱸 ������');											
			fm.udt_firm.value = '�뱸 ������';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '6'){
			fm.udt_firm.options[1] = new Option('������ڵ�����ǰ��', '������ڵ�����ǰ��');											
			fm.udt_firm.value = '������ڵ�����ǰ��';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '4'){
			fm.udt_firm.options[1] = new Option('<%=client.getFirm_nm()%>', '<%=client.getFirm_nm()%>');											
			fm.udt_firm.value = '<%=client.getFirm_nm()%>';
			cng_input1(fm.udt_firm.value);
		}			
	}	
		
	//�����μ��� ���ý� ��ǰ��ü ����
	function cng_input1(value){
		var fm = document.form1;
		
		if(fm.udt_firm.value == '������ ����������'){					
			fm.udt_addr.value 	= '����� �������� �������� 34�� 9';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_s.getDept_nm()%> <%=udt_mng_bean_s.getUser_nm()%> <%=udt_mng_bean_s.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_s.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_s.getUser_id()%>';			
		}else if(fm.udt_firm.value == '����ī(������)'){				
			fm.udt_addr.value 	= '�λ걤���� ������ ����4�� 700-5';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b.getDept_nm()%> <%=udt_mng_bean_b.getUser_nm()%> <%=udt_mng_bean_b.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b.getUser_id()%>';			
		}else if(fm.udt_firm.value == '������������� ������'){					
			fm.udt_addr.value 	= '�λ걤���� ������ ����4�� 585-1';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';			
		}else if(fm.udt_firm.value == '������TS'){			
			fm.udt_addr.value 	= '�λ�� ������ �ȿ���7������ 10(���굿 363-13����)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';	
		}else if(fm.udt_firm.value == '�����̵���ǽ��� ����1�� ������'){					
			fm.udt_addr.value 	= '�λ걤���� ������ ����õ�� 230���� 70 ����1�� (���굿,�����̵���ǽ���)�����̵�������';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';			
		}else if(fm.udt_firm.value == '����ī��ǰ'){			
			fm.udt_addr.value 	= '���������� ������ ������ 527-5';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_d.getDept_nm()%> <%=udt_mng_bean_d.getUser_nm()%> <%=udt_mng_bean_d.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_d.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_d.getUser_id()%>';						
		}else if(fm.udt_firm.value == '�̼���ũ'){				
			fm.udt_addr.value = '���������� ������ ��õ�Ϸ�59���� 10(���� 690-3)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_d.getDept_nm()%> <%=udt_mng_bean_d.getUser_nm()%> <%=udt_mng_bean_d.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_d.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_d.getUser_id()%>';			
		}else if(fm.udt_firm.value == '�뱸 ������'){				
			fm.udt_addr.value 	= '�뱸������ �޼��� �Ŵ絿 321-86';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_g.getDept_nm()%> <%=udt_mng_bean_g.getUser_nm()%> <%=udt_mng_bean_g.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_g.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_g.getUser_id()%>';			
		}else if(fm.udt_firm.value == '������ڵ�����ǰ��'){				
			fm.udt_addr.value 	= '���ֱ����� ���걸 �󹫴�� 233 (������ 1360)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_j.getDept_nm()%> <%=udt_mng_bean_j.getUser_nm()%> <%=udt_mng_bean_j.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_j.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_j.getUser_id()%>';			
		}else if(fm.udt_firm.value == '<%=client.getFirm_nm()%>'){				
			fm.udt_addr.value 	= '<%=client.getO_addr()%>';
			fm.udt_mng_nm.value 	= '<%=client.getCon_agnt_dept()%> <%=client.getCon_agnt_nm()%> <%=client.getCon_agnt_title()%>';
			fm.udt_mng_tel.value 	= '<%=client.getO_tel()%>';
			fm.udt_mng_id.value     = '';		
		}
					
	}

	function Save(){
		fm = document.form1;
	
		if(fm.rent_l_cd.value=='') { alert('����� ��ȸ�Ͻʽÿ�.'); return; }
		
		if(!confirm("��� �Ͻðڽ��ϱ�?"))	return;
		fm.action = "rePurcomReg_a.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
	function p_reload(){
		fm = document.form1;
		fm.action = "rePurcomReg.jsp";
		fm.target = "_self";
		fm.submit();
	}	


//-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="o_rent_mng_id" value="<%=o_rent_mng_id%>">
<input type="hidden" name="o_rent_l_cd" value="<%=o_rent_l_cd%>">
<input type="hidden" name="com_con_no" value="<%=com_con_no%>">
<input type="hidden" name="from_page" value="<%=from_page%>">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>"/>
<input type="hidden" name="car_off_nm" value="<%=co_bean.getCar_off_nm()%>">
<input type="hidden" name="car_nm" value="<%=AddUtil.replace(cpd_bean.getCar_nm(),"&nbsp;","")%>"/>
<input type="hidden" name="opt" value="<%=cpd_bean.getOpt()%>">
<input type="hidden" name="colo" value="<%=cpd_bean.getColo()%>">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td >
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>�������� �Է»���</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=13% class=title>�������</td>
                    <td width=17%>&nbsp;<%=co_bean.getCar_off_nm()%></td>
                    <td width=10% class=title>�����ȣ</td>
                    <td width=20%>&nbsp;<%=com_con_no%></td>
                    <td width=10% class=title>����</td>
                    <td width=30%>&nbsp;<%=cpd_bean.getCar_nm()%></td>
                </tr>
            </table>
        </td>
    </tr>     
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��࿬��</span></td>
    </tr> 
    <tr>
        <td class=line2></td>
    </tr>       
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>                     
                    <td width=14% class=title>����ȣ</td>
                    <td>&nbsp;<input type='text' size='15' name='rent_l_cd' maxlength='20' class='default' value='<%=rent_l_cd%>' readonly>
                    	<a href='javascript:search_cont()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>	
                    </td>
 		</tr>    		    
            </table>
        </td>
    </tr>  
    <!--
    <%if(!rent_l_cd.equals("")){%>    
    <tr>
        <td class=h></td>
    </tr>   
    <tr>
        <td class=line2></td>
    </tr>     
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="3" class=title>����</td>
                    <td width=7% class=title>����</td>
                    <td width=10%>&nbsp;
                        <%if(cpd_bean.getDlv_st().equals("2")){%>
                        [����]&nbsp;<%=AddUtil.ChangeDate2(cpd_bean.getDlv_con_dt())%>
        		            <%}else{%>
                        [����]&nbsp;<%=AddUtil.ChangeDate2(cpd_bean.getDlv_est_dt())%>
        		            <%}%>
        	          </td>
                    <td width=7% rowspan="3" class=title>�����</td>
                    <td width=7% class=title>����</td>
                    <td width="28%" >&nbsp;<select name="udt_st" class='default' onChange="javascript:setOff()">
                        <option value="">==����==</option>
        				<option value="1" <%if(cpd_bean.getUdt_st().equals("1"))%> selected<%%>>���ﺻ��</option>
        				<option value="2" <%if(cpd_bean.getUdt_st().equals("2"))%> selected<%%>>�λ�����</option>
        				<option value="3" <%if(cpd_bean.getUdt_st().equals("3"))%> selected<%%>>��������</option>
        				<option value="5" <%if(cpd_bean.getUdt_st().equals("5"))%> selected<%%>>�뱸����</option>
        				<option value="6" <%if(cpd_bean.getUdt_st().equals("6"))%> selected<%%>>��������</option>
        				<option value="4" <%if(cpd_bean.getUdt_st().equals("4"))%> selected<%%>>��</option>
        			  </select></td>
                    <td width="7%" rowspan="2" class=title>�����</td>
                    <td width="7%" class=title>�μ�/����</td>
                    <td width="20%">&nbsp;<input type='text' name='udt_mng_nm' size='29' value='<%=cpd_bean.getUdt_mng_nm()%>' class='whitetext' ></td>
    		    </tr>    		   
                <tr>
                  <td class=title>���繫��</td>
                  <td>&nbsp;<%=cpd_bean.getDlv_ext()%></td>
                  <td class=title>����/��ȣ</td>
                  <td >&nbsp;<select name="udt_firm" class='default' onChange="javascript:cng_input1(this.value);">
                            <option value="">==����==</option>
        		    <%if(cpd_bean.getUdt_st().equals("1")){%>
        		    <option value="������ ����������" <%if(cpd_bean.getUdt_firm().equals("������ ����������"))%> selected<%%>>������ ����������</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("2")){%>
        		    <option value="������������� ������" <%if(cpd_bean.getUdt_firm().equals("������������� ������"))%> selected<%%>>������������� ������</option>
        		    <option value="�����̵���ǽ��� ����1�� ������" <%if(cpd_bean.getUdt_firm().equals("�����̵���ǽ��� ����1�� ������"))%> selected<%%>>�����̵���ǽ��� ����1�� ������</option>
        		    <option value="����ī(������)" <%if(cpd_bean.getUdt_firm().equals("����ī(������)"))%> selected<%%>>����ī(������)</option>
        		    <option value="������TS" <%if(cpd_bean.getUdt_firm().equals("������TS"))%> selected<%%>>������TS</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("3")){%>
        		    <option value="�̼���ũ" <%if(cpd_bean.getUdt_firm().equals("�̼���ũ"))%> selected<%%>>�̼���ũ</option>				
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("5")){%>
        		    <option value="�뱸 ������" <%if(cpd_bean.getUdt_firm().equals("�뱸 ������"))%> selected<%%>>�뱸 ������</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("6")){%>
        		    <option value="������ڵ�����ǰ��" <%if(cpd_bean.getUdt_firm().equals("������ڵ�����ǰ��"))%> selected<%%>>������ڵ�����ǰ��</option>				
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("4")){%>
     			    <option value="<%=client.getFirm_nm()%>" <%if(cpd_bean.getUdt_firm().equals(client.getFirm_nm()))%> selected<%%>><%=client.getFirm_nm()%></option>
     			    <%}%>
        		</select>
        		</td>
                  <td class=title>����ó</td>
                  <td>&nbsp;<input type='text' name='udt_mng_tel' size='29' value='<%=cpd_bean.getUdt_mng_tel()%>' class='whitetext' ></td>
                </tr>
                <tr>
                  <td class=title>���Ź�۷�</td>
                  <td>&nbsp;<input type='text' name='cons_amt' maxlength='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
                  <td class=title>�ּ�</td>
                  <td colspan="4" >&nbsp;<input type='text' name='udt_addr' size='80' value='<%=cpd_bean.getUdt_addr()%>' class='whitetext' ></td>
                </tr>	
            </table>
        </td>
    </tr>    
    <tr>  
        <td align="right">        	
		        <a href="javascript:Save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
		        &nbsp;&nbsp;
		        <a href="javascript:this.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
	    </td>	
    </tr>                    
    <%}%>   
    -->
    <tr>  
        <td align="right">        	
		        <a href="javascript:Save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
		        &nbsp;&nbsp;
		        <a href="javascript:this.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
	    </td>	
    </tr>                    
    <tr>
        <td>&nbsp;</td>
    </tr>	
    <tr>
        <td>�� ������ �ϸ� ���� ���������� �״�� �ѱ�ϴ�. ������ ����, D/C, �������� ���� �����ϴ� ��࿡ �´��� Ȯ���Ͻʽÿ�.</td>
    </tr>	
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
