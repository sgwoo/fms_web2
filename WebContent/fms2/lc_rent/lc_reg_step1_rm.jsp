<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*"%> 
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%	
	//����ȣ ���� ������
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	
	LoginBean login = LoginBean.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();


	//�α���ID&������ID	
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "07");


	
	//������ ��ȸ
	Vector branches = c_db.getUserBranchs("rent"); 			//������ ����Ʈ	
	int brch_size = branches.size();
	
	//�ڵ���ȸ�� ����Ʈ	
	CarCompBean cc_r [] = umd.getCarCompAllNew("1");

	
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�ڵ������п� ���� ���÷���	
	function cng_input(){
		var fm = document.form1;
		
		fm.car_st.value 	= '4';
		fm.rent_st.value 	= '1';
		fm.rent_way.value 	= '1';
		fm.bus_st.value 	= '1';
			
		if(fm.car_name.value != '') fm.reset();
		td_01.style.display			= 'none';
		td_02.style.display			= '';
		td_11.style.display			= 'none';			
		td_12.style.display			= '';
		td_21.style.display			= 'none';
		td_22.style.display			= '';
		td_31.style.display			= 'none';
		td_32.style.display			= '';
		td_41.style.display			= 'none';
		td_42.style.display			= '';
		td_51.style.display			= 'none';
		td_52.style.display			= '';			
	}	
	
	//����ڵ忡 ������ �ڵ� �ֱ�
	function set_branch(){
		var fm = document.form1;
		var idx = fm.brch_id.selectedIndex;
		fm.con_cd1.value = fm.brch_id.options[idx].value;
		fm.mng_br_id[idx].selected = true;
	}

	//������ ��ȸ
	function car_search()
	{
		var fm = document.form1;
		var car_gu = "3";		
		window.open("search_ext_car.jsp?car_gu="+car_gu, "EXT_CAR", "left=100, top=100, width=800, height=600, status=yes");
	}	
	
	//����ڵ忡 �뿩���� �ڵ� �ֱ�
	function set_car_st(){
		var fm = document.form1;
		var car_st = fm.car_st.options[fm.car_st.selectedIndex].value;
		if(car_st == '1') 	fm.con_cd5.value = 'R';
		if(car_st == '2') 	fm.con_cd5.value = 'S';
		if(car_st == '3') 	fm.con_cd5.value = 'L';				
		if(car_st == '4') 	fm.con_cd5.value = 'M';				
		if(fm.con_cd5.value == 'S'){ 			//����
			tr_base1.style.display = 'none';
			tr_base2.style.display = 'none';
		}else{												//�뿩
			tr_base1.style.display = '';				// display = 'block'; ��� ��ü ���(ũ�ҿ��� ������ ���� ����) 2017. 11. 17 �ɺ�ȣ(������)
			tr_base2.style.display = '';
		}		
	}	
	
	//��ó�� ���� �ڵ��� ������ ����ϱ�
	function GetCarCompe(){
		var fm = document.form1;
		var fm2 = document.form2;
		var car_origin = fm.car_origin.options[fm.car_origin.selectedIndex].value;
		fm2.car_origin.value = car_origin;
		te = fm.car_comp_id;
		te.options[0].value = '';
		te.options[0].text = '��ȸ��';
		fm2.sel.value = "form1.car_comp_id";
		fm2.mode.value = '0';
		fm2.target="i_no";
		fm2.submit();		
	}
	
	//�ڵ���ȸ�� ���ý� �����ڵ� ����ϱ�
	function GetCarCode(){
		var fm = document.form1;
		var fm2 = document.form2;
		var car_comp_id = fm.car_comp_id.options[fm.car_comp_id.selectedIndex].value;
		fm.con_cd3.value = car_comp_id.substring(0,1);
		fm2.car_comp_id.value = car_comp_id.substring(1);
		te = fm.code;
		te.options[0].value = '';
		te.options[0].text = '��ȸ��';
		fm2.sel.value = "form1.code";
		fm2.mode.value = '1';
		fm2.target="i_no";
		fm2.submit();
	}
	
	//�����ڵ� ���ý� ����ڵ� ����ϱ�
	function GetCarCd(){
		var fm = document.form1;	
		var code = fm.code.options[fm.code.selectedIndex].text;
		fm.con_cd4.value = code.substring(1,3);
	}
		
	//���θ���Ʈ
	function sub_list(idx){
		var fm = document.form1;
		if(fm.car_comp_id.value == '')		{ 	alert('�ڵ���ȸ�縦 �����Ͻʽÿ�.'); 	return;}
		if(fm.code.value == '')			{ 	alert('������ �����Ͻʽÿ�.'); 		return;}
		var car_comp_id = fm.car_comp_id.options[fm.car_comp_id.selectedIndex].value.substring(1);
		var garnish_yn_opt_st = fm.garnish_yn_opt_st.value;
		var hook_yn_opt_st = fm.hook_yn_opt_st.value;
		var SUBWIN="search_esti_sub_list.jsp?idx="+idx+"&car_comp_id="+car_comp_id+"&car_cd="+fm.code.value+"&car_id="+fm.car_id.value+"&car_seq="+fm.car_seq.value+"&car_nm="+fm.code.options[fm.code.selectedIndex].text+"&garnish_yn_opt_st="+garnish_yn_opt_st+"&hook_yn_opt_st="+hook_yn_opt_st;	
		window.open(SUBWIN, "SubList", "left=100, top=100, width=650, height=500, scrollbars=yes, status=yes");
	}
	
	//�����ܰ�� �Ѿ��
	function save(){	
		var fm = document.form1;

		if(fm.rent_dt.value == '')		{ alert('������ڸ� Ȯ���Ͻʽÿ�.'); 		return;}



		//����Ʈ
		//if(fm.car_gu[2].checked == true){
			fm.con_cd5.value 	= "M";
			fm.car_st.value 	= "4";
			fm.rent_way.value 	= "1";			
			if(fm.rent_st.value == '') 	fm.rent_st.value 	= "1";
			if(fm.bus_st.value == '') 	fm.bus_st.value 	= "1";
		//}	


		if(fm.con_cd1.value == '')		{ alert('����ȣ�� Ȯ���Ͻʽÿ�.'); 		return;}
		if(fm.con_cd2.value == '')		{ alert('����ȣ�� Ȯ���Ͻʽÿ�.'); 		return;}
		if(fm.con_cd3.value == '')		{ alert('����ȣ�� Ȯ���Ͻʽÿ�.'); 		return;}
		if(fm.con_cd4.value == '')		{ alert('����ȣ�� Ȯ���Ͻʽÿ�.'); 		return;}
		if(fm.con_cd5.value == '')		{ alert('����ȣ�� Ȯ���Ͻʽÿ�.'); 		return;}
		if(fm.car_origin.value == '')		{ alert('��ó�� Ȯ���Ͻʽÿ�.'); 		return;}
		if(fm.mng_br_id.value == '')		{ alert('���������� Ȯ���Ͻʽÿ�.'); 		return;}
		if(fm.est_area.value == '')		{ alert('�����̿������� Ȯ���Ͻʽÿ�.'); 	return;}
		if(fm.county.value == '')		{ alert('�����̿�����(��/��)�� Ȯ���Ͻʽÿ�.'); 	return;}
		if(fm.est_area.value == '��/��')	{ alert('�����̿�����(��/��)�� Ȯ���Ͻʽÿ�.'); 	return;}
		if(fm.county.value == '��/��')		{ alert('�����̿�����(��/��)�� Ȯ���Ͻʽÿ�.'); 	return;}
		
		
		
		
								
		//�������� �ƴ� ���
		if(fm.car_st.value != '2'){	
			if(fm.bus_id.value == '')	{ alert('���ʿ����ڸ� Ȯ���Ͻʽÿ�.'); 		return;}
			if(fm.rent_st.value == '')	{ alert('��౸���� Ȯ���Ͻʽÿ�.'); 		return;}
			if(fm.bus_st.value == '')	{ alert('���������� Ȯ���Ͻʽÿ�.'); 		return;}
			if(fm.rent_way.value == '')	{ alert('���������� Ȯ���Ͻʽÿ�.'); 		return;}	
			if(fm.bus_id.value.substring(0,1) == '1')	{ alert('���ʿ����ڰ� �μ��� ���õǾ����ϴ�. Ȯ�����ּ���.'); return; }		
			if(fm.bus_agnt_id.value.substring(0,1) == '1')	{ alert('�����븮���� �μ��� ���õǾ����ϴ�. Ȯ�����ּ���.'); return; }					
		}
		
		//������ ���
		if(fm.rent_st.value == '3'){	
		//	if(fm.grt_suc_l_cd.value == '')	{ alert('������ ������� �Է��Ͻʽÿ�.'); 	return;}
		}
		
		
		fm.con_cd.value = fm.con_cd1.value+fm.con_cd2.value+fm.con_cd3.value+fm.con_cd4.value+fm.con_cd5.value;
		
		if(confirm('1�ܰ踦 ����Ͻðڽ��ϱ�?')){	
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");
					
			fm.action='lc_reg_step1_a.jsp';		
			fm.target='d_content';
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}		
	}
	
	function setColAmt(){
		var fm = document.form1;				
		
	}
	
	//���� �������ȸ
	function search_suc_cont()
	{
		var fm = document.form1;	
		window.open("search_suc_cont.jsp", "SERV_SUC_CONT", "left=10, top=10, width=800, height=500, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	function cng_suc_input(){
		var fm = document.form1;	
		if(fm.rent_st.value == '3'){
			tr_suc.style.display	= '';
		}else{
			tr_suc.style.display	= 'none';
		}		
	}
	
	//������ȸ
	function User_search(nm, idx)
	{
		var fm = document.form1;
		var t_wd = '';
		if(idx == '')	t_wd = fm.user_nm.value;
		else  		t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');		
		fm.action = "/fms2/lc_rent/search_user.jsp?mode=EMP_Y&nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();		
	}				
//-->
</script>
<script language='javascript'>
<!--
     	var cnt = new Array();
     	cnt[0] = new Array('��/��');
     	cnt[1] = new Array('��/��','������','������','���ϱ�','������','���Ǳ�','������','���α�','��õ��','�����','������','���빮��','���۱�','������','���빮��','���ʱ�','������','���ϱ�','���ı�','��õ��','��������','��걸','����','���α�','�߱�','�߶���');
     	cnt[2] = new Array('��/��','������','������','����','����','������','�λ�����','�ϱ�','���','���ϱ�','����','������','������','������','�߱�','�ؿ�뱸','���屺');
     	cnt[3] = new Array('��/��','����','�޼���','����','�ϱ�','����','������','�߱�','�޼���');
     	cnt[4] = new Array('��/��','��籸','����','������','����','����Ȧ��','����','����','������','�߱�','��ȭ��','������');
     	cnt[5] = new Array('��/��','���걸','����','����','�ϱ�','����');
     	cnt[6] = new Array('��/��','�����','����','����','������','�߱�');
     	cnt[7] = new Array('��/��','����','����','�ϱ�','�߱�','���ֱ�');
		 	cnt[8] = new Array('��/��','����Ư����ġ��');     	
     	cnt[9] = new Array('��/��','�����','��õ��','������','������','������','�����ֽ�','����õ��','��õ��','������','������','�����','�Ȼ��','�Ⱦ��','�����','�ǿս�','�����ν�','���ý�','�ϳ���','����','���ֽ�','������','�ȼ���','���ֽ�','����','���ֱ�','��õ��','���ν�','��õ��','���ֽ�','��õ��','ȭ����');
     	cnt[10] = new Array('��/��','������','���ؽ�','��ô��','���ʽ�','���ֽ�','��õ��','�¹��','������','�籸��','��籺','������','������','������','ö����','��â��','ȫõ��','ȭõ��','Ⱦ����');
     	cnt[11] = new Array('��/��','��õ��','û�ֽ�','���ֽ�','���걺','�ܾ籺','������','������','��õ��','������','��õ��','û����','����');
     	cnt[12] = new Array('��/��','���ֽ�','���ɽ�','�����','�ƻ��','õ�Ƚ�','�ݻ걺','���걺','������','�ο���','��õ��','���ⱺ','���걺','û�籺','�¾ȱ�','ȫ����');
     	cnt[13] = new Array('��/��','�����','������','������','�ͻ��','���ֽ�','������','��â��','���ֱ�','�ξȱ�','��â��','���ֱ�','�ӽǱ�','�����','���ȱ�');
     	cnt[14] = new Array('��/��','�����','���ֽ�','������','��õ��','������','��õ��','������','���ﱺ','���','���ʱ�','��籺','���ȱ�','������','�žȱ�','��õ��','������','���ϱ�','�ϵ���','�强��','���ﱺ','������','����','�س���','ȭ����');
     	cnt[15] = new Array('��/��','����','���ֽ�','���̽�','��õ��','�����','���ֽ�','�ȵ���','���ֽ�','��õ��','���׽�','���ɱ�','������','��ȭ��','���ֱ�','������','���籺','��õ��','�︪��','������','�Ǽ���','û����','û�۱�','ĥ�');
     	cnt[16] = new Array('��/��','������','���ؽ�','�����','�о��','��õ��','����','���ֽ�','���ؽ�','â����','�뿵��','��â��','������','���ر�','��û��','����','�Ƿɱ�','â�籺','�ϵ���','�Ծȱ�','�Ծ籺','��õ��');
     	cnt[17] = new Array('��/��','��������','���ֽ�','�����ֱ�','�����ֱ�');

     	function county_change(add) {
     		var sel=document.form1.county
       		/* �ɼǸ޴����� */
       		for (i=sel.length-1; i>=0; i--){
        		sel.options[i] = null
        	}
       		/* �ɼǹڽ��߰� */
       		for (i=0; i < cnt[add].length;i++){                     
        		sel.options[i] = new Option(cnt[add][i], cnt[add][i]);
        	}         
     	}
//-->
</script>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body leftmargin="15">
<form action="get_car_mst_null.jsp" name="form2" method="post">
  <input type="hidden" name="sel" value="">
  <input type="hidden" name="car_origin" value="">
  <input type="hidden" name="car_comp_id" value="">  
  <input type="hidden" name="code" value="">
  <input type="hidden" name="car_id" value="">
  <input type="hidden" name="view_dt" value="">    
  <input type="hidden" name="t_wd" value="">      
  <input type="hidden" name="auth_rw" value="">
  <input type="hidden" name="mode" value="">
</form>
<form name='form1' action='' method='post'>
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">    
  <input type="hidden" name="con_cd" value="">
  <input type="hidden" name="jg_tuix_st" value=""><!-- search_esti_sub_list.jsp ���Ͽ��� ��ũ��Ʈ ������ �߻��ϴ� ���� �����ϱ� ���� �߰� START -->
  <input type="hidden" name="jg_tuix_opt_st" value=""><!-- 2017-11-15 -->
  <input type="hidden" name="lkas_yn" value="">				<!-- ������Ż ������ -->
  <input type="hidden" name="lkas_yn_opt_st" value="">	<!-- ������Ż ������ (�ɼ�) -->
  <input type="hidden" name="ldws_yn" value="">				<!-- ������Ż ����� -->
  <input type="hidden" name="ldws_yn_opt_st" value="">	<!-- ������Ż ����� (�ɼ�) -->
  <input type="hidden" name="aeb_yn" value="">				<!-- ������� ������ -->
  <input type="hidden" name="aeb_yn_opt_st" value="">	<!-- ������� ������ (�ɼ�) -->
  <input type="hidden" name="fcw_yn" value="">				<!-- ������� ����� -->
  <input type="hidden" name="fcw_yn_opt_st" value="">	<!-- ������� ����� (�ɼ�) -->
  <input type="hidden" name="ev_yn" value="">				<!-- ������ ���� / ����Ʈ ���� -->
  <input type="hidden" name="conti_rat" value="">
  <input type="hidden" name="conti_rat_seq" value="">
  <input type="hidden" name="jg_opt_st" value="">
  <input type="hidden" name="jg_col_st" value=""><!-- �߰� END -->
  <input type="hidden" name="garnish_yn" value="">				<!-- ���Ͻ� ���� -->
  <input type="hidden" name="garnish_yn_opt_st" value="">	<!-- ���Ͻ� ����(�ɼ�) -->
  <input type="hidden" name="hook_yn" value="">				<!-- ���ΰ��� ���� -->
  <input type="hidden" name="hook_yn_opt_st" value="">	<!-- ���ΰ��� ����(�ɼ�) -->
  <input type="hidden" name="others_device" value="">
  <input type="hidden" name="top_cng_yn" value="">
  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ý��� > �������� > <span class=style5>����Ʈ�����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td align='left'>&nbsp;</td>
    </tr>
    <tr>
        <td align='left'>&nbsp;&nbsp;<span class=style2> <font color=red>[1�ܰ�]</font>   ����ȣ ���� �� ���ʻ��� �Է�</span></td>
    </tr>
    <tr>
        <td align='left'>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='13%' class='title'> ����ȣ </td>
                    <td width="87%">&nbsp; 
        	      <input type='text' class='fix' name='con_cd1' size='2' value='' readonly>
                      -
                      <input type='text' class='fix' name='con_cd2' size='2' value='<%=AddUtil.getDate().substring(2,4)%>' readonly>
                      -
                      <input type='text' class='fix' name='con_cd3' size='1' value='' readonly>
                      -
                      <input type='text' class='fix' name='con_cd4' size='2' readonly>
                      -
                      <input type='text' class='fix' name='con_cd5' size='1' readonly>
                      -00000
        	    </td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td align='left'>
	    &nbsp;
		<input type='radio' name="car_gu" value='3' onClick="javascript:cng_input()" checked>
		����Ʈ
		
	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>
    		<table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td colspan="2" class='title'>�׸�</td>
                    <td width="70%" class='title'>����</td>
                    <td width="17%" class='title'>�ݾ�</td>
                </tr>
                <tr> 
                    <td colspan="2" class='title'>��������</td>
                    <td>&nbsp; 
                      <select name='brch_id' onChange='javascript:set_branch()'>
                        <option value=''>����</option>
                      <%		for (int i = 0 ; i < brch_size ; i++){
        							Hashtable branch = (Hashtable)branches.elementAt(i);%>
                        <option value='<%=branch.get("BR_ID")%>'><%= branch.get("BR_NM")%></option>
                      <%		}%>
                      </select>&nbsp;
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td colspan="2" class='title'>������ȣ</td>
                    <td>&nbsp;
        			  <input type='text'   name='car_no' class='fix' size='15' readonly>
        			  <input type='hidden' name='car_mng_id' value=''>
        			  <input type='hidden' name='old_rent_mng_id' value=''>
        			  <input type='hidden' name='old_rent_l_cd' value=''>
        			  <input type='hidden' name='car_use' value=''>
                      <a href="javascript:car_search();"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td width="3%" rowspan="7" class='title'>��<br>
                    ��<br>��</td>
                    <td width="10%" class='title'>��ó</td>
                    <td><table width="100%" border="0" cellpadding="0">
                        <tr>
                          <td id=td_01 style="display:''">&nbsp;
                            <select name="car_origin" onChange="javascript:GetCarCompe()" class='default'>
                              <option value="">����</option>
                              <option value="1" selected>����</option>
                              <option value="2">����</option>
                            </select></td>
                          <td id=td_02 style='display:none'>&nbsp;
        				  <input type='text' name="car_origin_nm" size='60' class='fix' readonly></td>
                        </tr>
                      </table>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class='title'>����ȸ��</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                              <td id=td_11 style="display:''">&nbsp;
                          		<select name="car_comp_id" onChange="javascript:GetCarCode()">
            					  <option value="">����</option>
                            	<%	for(int i=0; i<cc_r.length; i++){
            					  		cc_bean = cc_r[i];%>
                            	  <option value="<%= cc_bean.getNm_cd() %><%= cc_bean.getCode() %>"><%= cc_bean.getNm() %></option>
                            	<%	}	%>
                          		</select>
            				</td>
                              <td id=td_12 style='display:none'>&nbsp;
                                  <input type='text' name="car_comp_nm" size='60' class='fix' readonly></td>
                            </tr>
                        </table>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td id=td_21 style="display:''">&nbsp;                    
                					<select name="code" onChange="javascript:GetCarCd()">
                                	  <option value="">����</option>
                              		</select>
                					&nbsp; </td>
                                <td id=td_22 style='display:none'>&nbsp;
            				    <input type='text' name="car_nm" size='60' class='fix' readonly></td>
                            </tr>
                        </table> 
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width=7% id=td_31 style="display:''">&nbsp;                    
            					    <a href="javascript:sub_list('1');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
            				    </td>
                                <td id=td_32 style="display:''">&nbsp;
                				  	<input type='text' name="car_name" size='60' class='fix' readonly>
                			  		<input type='hidden' name='car_id' value=''>
                			  		<input type='hidden' name='car_seq' value=''>
                					<input type='hidden' name='car_s_amt' value=''>
                					<input type='hidden' name='car_v_amt' value=''>
                					<input type='hidden' name='auto_yn' value=''>
                					<input type='hidden' name='car_b' value=''>
                					</td>
                            </tr>
                        </table>
                    </td>
                    <td align="center"><input type='text' name='car_amt' size='10' value='' maxlength='15' class='fixnum' readonly>
        			  ��</td>
                </tr>
                <tr> 
                    <td class='title'>�ɼ�</td>
                    <td>
        			    <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width=7% id=td_41 style="display:''">&nbsp;
            				        <a href="javascript:sub_list('2');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>					
                                </td>
                                <td id=td_42 style="display:''">&nbsp;
            				    <input type='text' name="opt" size='60' class='fix' readonly>
            				    <input type='hidden' name='opt_seq' value=''>
            				    <input type='hidden' name='opt_s_amt' value=''>
            				    <input type='hidden' name='opt_v_amt' value=''></td>
                            </tr>
                        </table>
                    </td>
                    <td align="center"><input type='text' name='opt_amt' size='10' value='' maxlength='13' class='fixnum' readonly>��</td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width=7% id=td_51 style="display:''">&nbsp;
            				        <a href="javascript:sub_list('3');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                                </td>
                                <td id=td_52 style="display:''">&nbsp;
            				    <input type='text' name="col" size='50' class='text'>
								(�������(��Ʈ): <input type='text' name="in_col" size='20' class='text'> )
								(���Ͻ�: <input type='text' name="garnish_col" size='20' class='text'> )
            				    <input type='hidden' name='col_seq' value=''>
            				    <input type='hidden' name='col_s_amt' value=''>
            				    <input type='hidden' name='col_v_amt' value=''></td>
                            </tr>
                        </table>
                    </td>
                    <td align="center"><input type='text' name='col_amt' size='10' value='' maxlength='13' class='num' onBlur="javascript:setColAmt()">��</td>
                </tr>
                <tr>
                    <td colspan="2" class='title'>��������</td>
                    <td align="center"><input type='text' name='o_1' size='10' value='' maxlength='13' class='fixnum' readonly>					
        				��<input type='hidden' name='o_1_s_amt' value=''><input type='hidden' name='o_1_v_amt' value=''></td>
                </tr>
                <tr> 
                    <td colspan="2" class='title'>�뵵����</td>
                    <td>&nbsp; 
                        <select name="car_st" onChange='javascript:set_car_st()'>
                            <option value="4">����Ʈ</option>
                        </select>
                        &nbsp; </td>
                    <td>&nbsp;</td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
        <td align='left'>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
    	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=13%>�������</td>
                    <td  colspan="5">&nbsp;
                    <input type="text" name="rent_dt" value="<%=AddUtil.getDate()%>" size="11" maxlength='10' class='default' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
                <tr id=tr_base2 style="display:''">
                    <td class=title>��౸��</td>
                    <td>&nbsp;
                        <select name="rent_st" onChange="javascript:cng_suc_input()">
                          <option value=''>����</option>
                          <option value='1'>�ű�</option>
                          <option value='3'>����</option>
                          <option value='4'>����</option>
                        </select></td>
                    <td class=title>��������</td>
                    <td>&nbsp;
                        <select name="bus_st">
                          <option value="">����</option>
                          <option value="1">���ͳ�</option>
                          <option value="8">�����</option>
                          <option value="5">��ȭ���</option>
                          <option value="2">�������</option>
                          <option value="7">������Ʈ</option>
                          <option value="6">������ü</option>
                          <option value="3">��ü�Ұ�</option>
                          <option value="4">catalog</option>                                                    
                        </select></td>
                    <td class=title>��������</td>
                    <td>&nbsp;
                        <select name="rent_way">
                          <!--<option value="">����</option>-->
                          <option value="1">�Ϲݽ�</option>
                          <!--<option value="3">�⺻��</option>-->
                        </select></td>
                </tr>
                <tr id=tr_base1 style="display:''">
                    <td class=title>��������</td>
                    <td>&nbsp;
                        <select name='mng_br_id'>
                            <option value=''>����</option>
                            <%	if(brch_size > 0)	{
            						for (int i = 0 ; i < brch_size ; i++){
            							Hashtable branch = (Hashtable)branches.elementAt(i);%>
                            <option value='<%=branch.get("BR_ID")%>'><%= branch.get("BR_NM")%></option>
                            <%		}
            					}%>
                        </select>
                    </td>
                    <td class=title>���ʿ�����</td>
                    <td width="20%" >&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(user_id, "USER")%>" size="12"> 
			<input type="hidden" name="bus_id" value="<%=user_id%>">
			<a href="javascript:User_search('bus_id', '0');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>		        
                    </td>
                    <td width="10%" class=title>�����븮��</td>
                    <td width="27%">&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="" size="12"> 
			<input type="hidden" name="bus_agnt_id" value="">
			<a href="javascript:User_search('bus_agnt_id', '1');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>		        
                    </td>
                </tr>	
                <tr>
                    <td class=title width=13%>�����̿�����</td>
                    <td  colspan="5">&nbsp;
 								<select name='est_area' onchange="county_change(this.selectedIndex);">
								   <option value=''>��/��</option>
								   <option value='����'>����Ư����</option>
								   <option value='�λ�'>�λ걤����</option>
								   <option value='�뱸'>�뱸������</option>
								   <option value='��õ'>��õ������</option>
								   <option value='����'>���ֱ�����</option>
								   <option value='����'>����������</option>
								   <option value='���'>��걤����</option>
								   <option value='����'>����Ư����ġ��</option>
								   <option value='���'>��⵵</option>
								   <option value='����'>������</option>
								   <option value='���'>��û�ϵ�</option>
								   <option value='�泲'>��û����</option>
								   <option value='����'>����ϵ�</option>
								   <option value='����'>���󳲵�</option>
								   <option value='���'>���ϵ�</option>
								   <option value='�泲'>��󳲵�</option>
								   <option value='����'>���ֵ�</option>
								</select>&nbsp;
								<select name='county'>
								   <option value=''>��/��</option>
								</select>  
					</td>
                </tr>					  
            </table>
	    </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>	
    <tr id=tr_suc style='display:none'>
        <td class='line'>            
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class='title' width=13%>���� �����</td>
                    <td>&nbsp; 
                      <span class="b"><a href="javascript:search_suc_cont()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
					  &nbsp;����ȣ : <input type='text' name='grt_suc_l_cd' size='15' value='' class='whitetext' >
					  &nbsp;������ȣ : <input type='text' name='grt_suc_c_no' size='15' value='' class='whitetext' >
					    <input type="hidden" name="grt_suc_m_id" value="">
                    </td>
                </tr>
            </table>
	    </td>
    </tr>		
    <tr>
        <td>&nbsp;</td>
    </tr>
	<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
    <tr>
	    <td align='right'><a id="submitLink" href="javascript:save();"><img src=/acar/images/center/button_next.gif align=absmiddle border=0></a></td>
	</tr>
	<%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--
	//�������� �α������� �Ҽ��������� ����
	document.form1.brch_id.value = '<%=br_id%>';
	set_branch();
	
	cng_input();
	
	set_car_st();
//-->
</script>
</body>
</html>