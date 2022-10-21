<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*,acar.client.*,acar.common.*, acar.user_mng.*, acar.settle_acc.*, acar.cls.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String rent_st  	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String fee_rent_st 	= request.getParameter("fee_rent_st")==null?"1":request.getParameter("fee_rent_st");
	String cmd	  	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String c_st = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	

	
	if(from_page.equals("/fms2/cooperation/cooperation_n2_sc.jsp")){
		Hashtable cont_ht = s_db.getContSettleInfo(rent_l_cd);
		if(!String.valueOf(cont_ht.get("RENT_L_CD")).equals("")){
			rent_mng_id = String.valueOf(cont_ht.get("RENT_MNG_ID"));
			rent_st 	= String.valueOf(cont_ht.get("RENT_ST"));
		}
	}
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);
	
	
	//�����Ҹ���Ʈ
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();
	
	Vector vt = a_db.getLcRentCngHList(rent_mng_id, rent_l_cd, cng_item);
	int vt_size = vt.size();
	
	String item_nm = "";
	if(cng_item.equals("bus_id2")) 		item_nm = "���������";
	if(cng_item.equals("mng_id")) 		item_nm = "���������";
	if(cng_item.equals("mng_id2")) 		item_nm = "���������";
	if(cng_item.equals("car_st")) 		item_nm = "�뵵����";
	if(cng_item.equals("rent_way")) 	item_nm = "��������";
	if(cng_item.equals("mng_br_id")) 	item_nm = "��������";
	if(cng_item.equals("grt_amt")) 		item_nm = "������";
	if(cng_item.equals("pp_amt")) 		item_nm = "������";
	if(cng_item.equals("ifee_amt")) 	item_nm = "���ô뿩��";
	if(cng_item.equals("fee_amt")) 		item_nm = "�뿩��";
	if(cng_item.equals("inv_amt")) 		item_nm = "����뿩��";
	if(cng_item.equals("bus_st")) 		item_nm = "��������";
	if(cng_item.equals("est_area"))		item_nm = "�����̿�����";
	if(cng_item.equals("bus_id")) 		item_nm = "���ʿ�����";	
	if(cng_item.equals("bus_agnt_id")) 	item_nm = "�����븮��";
	if(cng_item.equals("opt_amt")) 		item_nm = "���Կɼ�";
	if(cng_item.equals("suc_cls_dt")) 	item_nm = "�°���������";
	
	Vector vt2 = new Vector();
	//����������� ��� ���ϰŷ�ó�� ��������ڰ� �������϶� ����Ʈ Ȯ��
	if(cng_item.equals("bus_id2")){
		vt2 = a_db.getLcRentClientBusid2(base.getClient_id());
	}
	int vt_size2 = vt2.size();
	
		
	//������ �޼��� �ޱ� ����.
	
	String mode = "";		
	String s_br = "";		
	String est_area = cont_etc.getEst_area();
	String county = cont_etc.getCounty();

	if(est_area.equals("����")){
		if(county.equals("������")||county.equals("������")||county.equals("������")||county.equals("���빮��")||county.equals("���ʱ�")||county.equals("������")||county.equals("���ı�")||county.equals("�߶���")){
			mode = "MESSAGE_K";
			s_br = "S2";
		}else{
			mode = "MESSAGE_S";
			s_br = "S1";
		}
	}else if(est_area.equals("���")){
		if(county.equals("��õ��")||county.equals("������")||county.equals("�ϳ���")||county.equals("���ֽ�")){
			mode = "MESSAGE_K";
			s_br = "S2";
		}else if(county.equals("������")||county.equals("��õ��")||county.equals("�����")){
			mode = "MESSAGE_I";
			s_br = "I1";
		}else if(county.equals("����")||county.equals("�����")||county.equals("�Ⱦ��")||county.equals("���ֽ�")){
			mode = "MESSAGE_S";
			s_br = "S1";
		}else if(county.equals("������")||county.equals("������")||county.equals("�Ȼ��")||county.equals("�ȼ���")||county.equals("���ֱ�")||county.equals("�����")||county.equals("���ν�")||county.equals("�ǿս�")||county.equals("��õ��")||county.equals("���ý�")||county.equals("ȭ����")){
			mode = "MESSAGE_W";
			s_br = "K3";
		}else if(county.equals("����")||county.equals("������")||county.equals("�����ֽ�")||county.equals("����õ��")||county.equals("���ֽ�")||county.equals("����")||county.equals("��õ��")||county.equals("�����ν�")||county.equals("��õ��")){
			mode = "MESSAGE_S";	//��ȭ������ ������ ��ȭ���������� ����.		
			s_br = "S1";
		}else{
			mode = "MESSAGE_S";
			s_br = "S1";
		}
	}else if(est_area.equals("��õ")){		
			mode = "MESSAGE_I";
			s_br = "I1";		
	}else if(est_area.equals("����")){
		if(county.equals("��õ��")||county.equals("�籸��")||county.equals("ö����")||county.equals("ȭõ��")||county.equals("ȫõ��")||county.equals("������")||county.equals("����")||county.equals("���ʽ�")||county.equals("��籺")){
			mode = "MESSAGE_S";
			s_br = "S1";
		}else if(county.equals("���ֽ�")||county.equals("Ⱦ����")||county.equals("��â��")||county.equals("������")||county.equals("������")||county.equals("������")||county.equals("�¹��")||county.equals("���ؽ�")||county.equals("��ô��")){
			mode = "MESSAGE_W";
			s_br = "K3";
		}
	}else if(est_area.equals("�泲")||est_area.equals("�λ�")||est_area.equals("����") ){
		mode = "MESSAGE_B";
		s_br = "B1";
	}else if( est_area.equals("���") ){
		mode = "MESSAGE_U";
		s_br = "U1";	
	}else if(est_area.equals("����")||est_area.equals("����")){
		mode = "MESSAGE_J";
		s_br = "J1";
	}else if(est_area.equals("����")){
		if(county.equals("�����")||county.equals("������")||county.equals("�ͻ��")||county.equals("���ֽ�")){
			mode = "MESSAGE_J";
			s_br = "J1";
		}else{
			mode = "MESSAGE_J";
			s_br = "J1";
		}
	}else if(est_area.equals("���")){
		//if(county.equals("���̽�")||county.equals("������")||county.equals("��õ��")||county.equals("�����")||county.equals("��ȭ��")||county.equals("���ֽ�")||county.equals("���ֱ�")||county.equals("�ȵ���")||county.equals("���ֽ�")||county.equals("��õ��")||county.equals("�︪��")||county.equals("�Ǽ���")||county.equals("ĥ�")){
		//	mode = "MESSAGE_D";
		//	s_br = "D1";
		//}else{
		//	mode = "MESSAGE_B";
		//	s_br = "B1";			
			mode = "MESSAGE_G";
			s_br = "G1";
		//}
	}else if(est_area.equals("�뱸")){
		//if(county.equals("�ϱ�")||county.equals("����")){
		//	mode = "MESSAGE_D";
		//	s_br = "D1";
		//}else{
		//	mode = "MESSAGE_B";
		//	s_br = "B1";
		//}		
		mode = "MESSAGE_G";
		s_br = "G1";
	}else if(est_area.equals("�泲")||est_area.equals("���")||est_area.equals("����")||est_area.equals("����")){
		mode = "MESSAGE_D";
		s_br = "D1";	
	}
	
	if(s_br.equals("S2") || s_br.equals("I1")) s_br = "S1";		//����, ��õ���� ��������� ���翡�� 
	
	

		



%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//����ϱ�
	function save(){
		fm = document.form1;
						
		if(fm.new_value.value == ""){		alert("�����ĸ� �Է��� �ּ���!");		fm.new_value.focus();	return;	}
		
		<%if(item_nm.equals("���������")||item_nm.equals("���������")||item_nm.equals("���������")||item_nm.equals("�����븮��")){%>
		//if(fm.new_value.value.substring(0,1) == '1')	{ alert('�μ��� ���õǾ����ϴ�. Ȯ�����ּ���.'); return; }
		<%}%>

		if(fm.cng_cau.value == ""){			alert("��������� �Է��� �ּ���!");		fm.cng_cau.focus();		return;	}
		
		if(!confirm("�����Ͻðڽ��ϱ�?"))	return;
		
		fm.target = "i_no";				
		fm.action = "cng_item_a.jsp";
		fm.submit();
	}
	
	<%if(item_nm.equals("������")||item_nm.equals("������")||item_nm.equals("���ô뿩��")||item_nm.equals("�뿩��")||item_nm.equals("����뿩��")||item_nm.equals("���Կɼ�")){%>
	function set_amt(){
		fm = document.form1;
		if(fm.cng_item.value == 'grt_amt'){
			fm.s_amt.value = fm.new_value.value;
			fm.v_amt.value = '0';
		}else{
			fm.s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.new_value.value))));
			fm.v_amt.value = parseDecimal(toInt(parseDigit(fm.new_value.value)) - toInt(parseDigit(fm.s_amt.value)));			
		}		
	}
	<%}%>
	
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
<%if(item_nm.equals("�����̿�����")){%>
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
     	cnt[9] = new Array('��/��','����','��õ��','�����','������','������','�����ֽ�','����õ��','��õ��','������','������','�����','�Ȼ��','�Ⱦ��','�����','�ǿս�','�����ν�','���ý�','�ϳ���','����','���ֽ�','������','�ȼ���','���ֽ�','����','���ֱ�','��õ��','���ν�','��õ��','���ֽ�','��õ��','ȭ����');
     	cnt[10] = new Array('��/��','������','���ؽ�','��ô��','���ʽ�','���ֽ�','��õ��','�¹��','����','�籸��','��籺','������','������','������','ö����','��â��','ȫõ��','ȭõ��','Ⱦ����');
     	cnt[11] = new Array('��/��','��õ��','û�ֽ�','���ֽ�','���걺','�ܾ籺','������','������','��õ��','������','��õ��','û����','����');
     	cnt[12] = new Array('��/��','���ֽ�','���ɽ�','�����','�ƻ��','õ�Ƚ�','�ݻ걺','��걺','������','�ο���','��õ��','���ⱺ','���걺','û�籺','�¾ȱ�','ȫ����');
     	cnt[13] = new Array('��/��','�����','������','������','�ͻ��','���ֽ�','������','��â��','���ֱ�','�ξȱ�','��â��','���ֱ�','�ӽǱ�','�����','���ȱ�');
     	cnt[14] = new Array('��/��','�����','���ֽ�','������','��õ��','������','��õ��','������','���ﱺ','���','���ʱ�','��籺','���ȱ�','������','�žȱ�','��õ��','������','���ϱ�','�ϵ���','�强��','���ﱺ','������','����','�س���','ȭ����');
     	cnt[15] = new Array('��/��','����','���ֽ�','���̽�','��õ��','�����','���ֽ�','�ȵ���','���ֽ�','��õ��','���׽�','��ɱ�','������','��ȭ��','���ֱ�','������','���籺','��õ��','�︪��','������','�Ǽ���','û����','û�۱�','ĥ�');
     	cnt[16] = new Array('��/��','������','���ؽ�','�����','�о��','��õ��','����','���ֽ�','���ؽ�','â����','�뿵��','��â��','����','���ر�','��û��','����','�Ƿɱ�','â�籺','�ϵ���','�Ծȱ�','�Ծ籺','��õ��');
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
<%}%>
</head>

<body>
<center>
<form name='form1' action='cng_item_a.jsp' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="cng_item" 		value="<%=cng_item%>">
  <input type='hidden' name="rent_st" 		value="<%=rent_st%>">  
  <input type='hidden' name="cmd" 			value="<%=cmd%>">  
  <input type='hidden' name="cng_size" 		value="<%=vt_size%>">    
    
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>����̷�</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
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
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='20%'>����ȣ</td>
                    <td width='20%' align="center"><%=rent_l_cd%></td>
    			    <td class='title' width='15%'>��ȣ</td>
                    <td width='45%'>&nbsp;<%=client.getFirm_nm()%></td>
                </tr>
                <%if(item_nm.equals("���������")){%>
                <tr> 
                    <td class='title' width='20%'>�����̿�����</td>
                    <td width='20%' align="center"><%=cont_etc.getEst_area()%>&nbsp;<%=cont_etc.getCounty()%></td>
    			    <td class='title' width='15%'>��������</td>
                    <td width='45%'>&nbsp;
                        <%if(mode.equals("MESSAGE_S")){%>����
                        <%}else if(mode.equals("MESSAGE_K")){%>��������
                        <%}else if(mode.equals("MESSAGE_I")){%>��õ����
                        <%}else if(mode.equals("MESSAGE_W")){%>��������
                        <%}else if(mode.equals("MESSAGE_B")){%>�λ�����
                        <%}else if(mode.equals("MESSAGE_J")){%>��������
                        <%}else if(mode.equals("MESSAGE_D")){%>��������
                        <%}else if(mode.equals("MESSAGE_G")){%>�뱸����        
                        <%}else if(mode.equals("MESSAGE_U")){%>�������                                        
                        <%}%>
                    </td>
                </tr>                
                <%}%>
            </table>
        </td>
    </tr>  
    <tr> 
        <td align="right"></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>		  	  
    <tr> 
        <td align="right" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="20%" class='title'>������ </td>
                    <td width="20%" class='title'>������</td>
                    <td width="30%" class='title' >�������</td>
                    <td width="15%" class='title' >��������</td>
                    <td width="15%" class='title' >������</td>			  
                </tr>
                <%//��������� �����̷¸���Ʈ
    			
    			if(vt_size > 0){
    				for (int i = 0 ; i < vt_size ; i++){
    					Hashtable ht = (Hashtable)vt.elementAt(i);
    					String old_value = String.valueOf(ht.get("OLD_VALUE"));
    					String new_value = String.valueOf(ht.get("NEW_VALUE"));%>
                <tr> 
                    <td align="center">
    			<%if(item_nm.equals("���������") || item_nm.equals("���������") || item_nm.equals("���������") || item_nm.equals("���ʿ�����") || item_nm.equals("�����븮��"))	{%><%=c_db.getNameById(old_value, "USER")%>
    			<%}else if(item_nm.equals("�뵵����"))									{%><%if(old_value.equals("1")){%>��Ʈ<%  }else if(old_value.equals("2")){%>����<%  }else if(old_value.equals("3")){%>����<%  }else if(old_value.equals("5")){%>�뵵����<%}%>
    			<%}else if(item_nm.equals("��������"))									{%><%if(old_value.equals("1")){%>�Ϲݽ�<%}else if(old_value.equals("3")){%>�⺻��<%}%>
    			<%}else if(item_nm.equals("��������"))									{%><%=c_db.getNameById(old_value,"BRCH")%>
    			<%}else if(item_nm.equals("������") || item_nm.equals("������") || item_nm.equals("���ô뿩��") || item_nm.equals("�뿩��")||item_nm.equals("����뿩��")||item_nm.equals("���Կɼ�")){%><%=AddUtil.parseDecimal(AddUtil.replace(old_value,",",""))%>
			    <%}else if(item_nm.equals("��������"))									{%><%if(old_value.equals("1")){%>���ͳ�<%}else if(old_value.equals("2")){%>�������<%}else if(old_value.equals("3")){%>��ü�Ұ�<%}else if(old_value.equals("4")){%>catalog<%}else if(old_value.equals("5")){%>��ȭ���<%}else if(old_value.equals("6")){%>������ü<%}else if(old_value.equals("7")){%>������Ʈ<%}else if(old_value.equals("8")){%>�����<%}%>
    			<%}else if(item_nm.equals("�����̿�����"))								{%><%=old_value%>
    			<%}else{%><%=old_value%>
    			<%}%>
    		    </td>
            <td align="center">
    			<%if(item_nm.equals("���������") || item_nm.equals("���������") || item_nm.equals("���������") || item_nm.equals("���ʿ�����") || item_nm.equals("�����븮��"))	{%><%=c_db.getNameById(new_value, "USER")%>
    			<%}else if(item_nm.equals("�뵵����"))									{%><%if(new_value.equals("1")){%>��Ʈ<%  }else if(new_value.equals("2")){%>����<%  }else if(new_value.equals("3")){%>����<%  }else if(new_value.equals("5")){%>�����뿩<%}%>
    			<%}else if(item_nm.equals("��������"))									{%><%if(new_value.equals("1")){%>�Ϲݽ�<%}else if(new_value.equals("3")){%>�⺻��<%}%>
    			<%}else if(item_nm.equals("��������"))									{%><%=c_db.getNameById(new_value,"BRCH")%>
    			<%}else if(item_nm.equals("������") || item_nm.equals("������") || item_nm.equals("���ô뿩��") || item_nm.equals("�뿩��")||item_nm.equals("����뿩��")||item_nm.equals("���Կɼ�")){%><%=AddUtil.parseDecimal(AddUtil.replace(new_value,",",""))%>
			    <%}else if(item_nm.equals("��������"))									{%><%if(new_value.equals("1")){%>���ͳ�<%}else if(new_value.equals("2")){%>�������<%}else if(new_value.equals("3")){%>��ü�Ұ�<%}else if(new_value.equals("4")){%>catalog<%}else if(new_value.equals("5")){%>��ȭ���<%}else if(new_value.equals("6")){%>������ü<%}else if(new_value.equals("7")){%>������Ʈ<%}else if(new_value.equals("8")){%>�����<%}%>
    			<%}else if(item_nm.equals("�����̿�����"))								{%><%=new_value%>
    			<%}else{%><%=new_value%>
    			<%}%>
    		    </td>
                    <td align="center" >
                  	<%=ht.get("CNG_CAU")%>  
    		    </td>
                    <td align="center" >
                  	<%=AddUtil.ChangeDate2(String.valueOf(ht.get("CNG_DT")))%>  
    		    </td>
                    <td align="center" >
                  	<%=c_db.getNameById(String.valueOf(ht.get("CNG_ID")), "USER")%>
    		    </td>
                </tr>
    		<%  		}
    			}
    		%>		
            </table>
        </td>
    </tr>
    <!--����������-->
    <%if(!cmd.equals("view") && !item_nm.equals("����뿩��")){%>
    <%	String cng_auth = "";%>	  
    <%	if(item_nm.equals("���ʿ�����")||item_nm.equals("���������")||item_nm.equals("���������")||(!base.getCar_st().equals("4") && item_nm.equals("�����븮��"))||item_nm.equals("���������")||item_nm.equals("��������")){ 		
    		if(nm_db.getWorkAuthUser("��������ں���",ck_acar_id)){ 	
    			cng_auth = "r"; 
    		}else{
    			if(base.getBus_id().equals(ck_acar_id) && item_nm.equals("���ʿ�����") && !cont_etc.getSpe_est_id().equals("") && base.getUse_yn().equals("")){
    				cng_auth = "r"; 
    			}
    		}
    	}
    %>
    <%if(base.getCar_st().equals("4") && item_nm.equals("�����븮��")){
    			cng_auth = "r"; 
	    }
    %>   		    
    <%	if(item_nm.equals("�����̿�����")){ 									
    		if(base.getBus_id().equals(ck_acar_id) || base.getBus_id2().equals(ck_acar_id) || nm_db.getWorkAuthUser("��������ں���",ck_acar_id)){ 	
    			cng_auth = "r"; 
    		}
    	}
    %>   		
    <%	if(item_nm.equals("�뵵����")||item_nm.equals("��������")||item_nm.equals("��������")){ 			
    		if(nm_db.getWorkAuthUser("�뿩��ĺ���", ck_acar_id)){ 	
    			cng_auth = "r"; 
    		}
    	}
    %>		
    <%	if(item_nm.equals("������")||item_nm.equals("������")||item_nm.equals("���ô뿩��") ||item_nm.equals("�뿩��")||item_nm.equals("����뿩��")||item_nm.equals("���Կɼ�")||item_nm.equals("�°���������")){
    		if(nm_db.getWorkAuthUser("ȸ�����", ck_acar_id)){ 	
    			cng_auth = "r"; 
    			c_st = "fee";
    		}
    	}
    %>	 
    <%if((cmd.equals("�Աݼ����� ����")||cmd.equals("�ſ��յ���� �Աݼ����� ����")) && (item_nm.equals("������")||item_nm.equals("������")||item_nm.equals("���ô뿩��"))){ 		cng_auth = "r"; c_st = "fee";}%>
     		
    <%	if(cng_auth.equals("r")){%>	  
    <tr>
	<td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=item_nm%> ����</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>	
    <tr> 
        <td align="right" class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
    		<tr>
    		    <td width="20%" class='title'>������</td>
    		    <td>&nbsp;
    		    <% String old_value2 = "";%>
    		    <%if(item_nm.equals("���������")){
    			    	old_value2 = base.getBus_id2();%>
    			    <%=c_db.getNameById(old_value2,"USER")%>
    			  <%}else if(item_nm.equals("���������")){
    			    	old_value2 = base.getMng_id();%>
    			    <%=c_db.getNameById(old_value2,"USER")%>
    			  <%}else if(item_nm.equals("���������")){
    			    	old_value2 = base.getMng_id2();%>
    			    <%=c_db.getNameById(old_value2,"USER")%>
    			  <%}else if(item_nm.equals("���ʿ�����")){
    			    	old_value2 = base.getBus_id();%>
    			    <%=c_db.getNameById(old_value2,"USER")%>
    			  <%}else if(item_nm.equals("�����븮��")){
    			    	old_value2 = cont_etc.getBus_agnt_id();%>
    			    <%=c_db.getNameById(old_value2,"USER")%>
    			  <%}else if(item_nm.equals("�뵵����")){
    			    	old_value2 = base.getCar_st();%>
    			    <%if(old_value2.equals("1")){%>��Ʈ<%  }else if(old_value2.equals("2")) {%>����<%  }else if(old_value2.equals("3")){%>����<%  }else if(old_value2.equals("5")){%>�����뿩<%}%>
    			  <%}else if(item_nm.equals("��������")){
    			    	old_value2 = fee.getRent_way();%>
    			    <%if(old_value2.equals("1")){%>�Ϲݽ�<%}else if(old_value2.equals("3")){%>�⺻��<%}%>
    			  <%}else if(item_nm.equals("��������")){
    			    	old_value2 = base.getBus_st();%>
    			    <%if(old_value2.equals("1")){%>���ͳ�<%}else if(old_value2.equals("2")){%>�������<%}else if(old_value2.equals("3")){%>��ü�Ұ�<%}else if(old_value2.equals("4")){%>catalog<%}else if(old_value2.equals("5")){%>��ȭ���<%}else if(old_value2.equals("6")){%>������ü<%}else if(old_value2.equals("7")){%>������Ʈ<%}else if(old_value2.equals("8")){%>�����<%}%>
    			  <%}else if(item_nm.equals("��������")){
    			    	old_value2 = cont_etc.getMng_br_id();%>
    			    <%=c_db.getNameById(old_value2,"BRCH")%>
    			  <%}else if(item_nm.equals("�����̿�����")){
    			    	old_value2 = cont_etc.getEst_area();%>
    			    <%=old_value2%> <%=cont_etc.getCounty()%>
    			  <%}else if(item_nm.equals("������")){
    			    	old_value2 = String.valueOf(fee.getGrt_amt_s());%>
    			    <%=AddUtil.parseDecimal(old_value2)%>
    			  <%}else if(item_nm.equals("������")){
    			    	old_value2 = String.valueOf(fee.getPp_s_amt()+fee.getPp_v_amt());%>
    			    <%=AddUtil.parseDecimal(old_value2)%>
    			  <%}else if(item_nm.equals("���ô뿩��")){
    			    	old_value2 = String.valueOf(fee.getIfee_s_amt()+fee.getIfee_v_amt());%>
    			    <%=AddUtil.parseDecimal(old_value2)%>
    			  <%}else if(item_nm.equals("�뿩��")){
    			    	old_value2 = String.valueOf(fee.getFee_s_amt()+fee.getFee_v_amt());%>
    			    <%=AddUtil.parseDecimal(old_value2)%>
    			  <%}else if(item_nm.equals("����뿩��")){
    			    	old_value2 = String.valueOf(fee.getInv_s_amt()+fee.getInv_v_amt());%>
    			    <%=AddUtil.parseDecimal(old_value2)%>
    			  <%}else if(item_nm.equals("���Կɼ�")){
    			    	old_value2 = String.valueOf(fee.getOpt_s_amt()+fee.getOpt_v_amt());%>
    			    <%=AddUtil.parseDecimal(old_value2)%>
    			  <%}else if(item_nm.equals("�°���������")){
    			    	old_value2 = cls.getCls_dt();%>
    			    <%=old_value2%>  
    			  <%}%>			  
    			    <input type='hidden' name="old_value" value="<%=old_value2%>">				  
    		    </td>			  
    		</tr>		
    		<tr>
    		    <td width="20%" class='title'>������</td>
    		    <td>&nbsp;
    			<%if(item_nm.equals("������")||item_nm.equals("������")||item_nm.equals("���ô뿩��")||item_nm.equals("�뿩��")||item_nm.equals("����뿩��")||item_nm.equals("���Կɼ�")){%>
    			    <input type='text' name='new_value' size='12' class='num' value="" onBlur='javascript:this.value=parseDecimal(this.value);set_amt();'>��
    			    &nbsp;&nbsp;&nbsp;&nbsp;
    			    ( ���ް� : <input type='text' name='s_amt' size='10' class='num' value="" onBlur='javascript:this.value=parseDecimal(this.value);'>�� / �ΰ��� : <input type='text' name='v_amt' size='10' class='num' value="" onBlur='javascript:this.value=parseDecimal(this.value);'>�� )
    			  
    			<%}else if(item_nm.equals("���������")||item_nm.equals("���������")||item_nm.equals("���������")||item_nm.equals("���ʿ�����")||item_nm.equals("�����븮��")){%>
                            <input name="user_nm" type="text" class="text"  readonly value="" size="12"> 
			    <input type="hidden" name="new_value" value="">			
			    <a href="javascript:User_search('new_value', '');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			    <%}else if(item_nm.equals("�°���������")){%>
                <input type="text" name="new_value" value="" size='12' maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'>   
    			<%}else{%>
                            <select name="new_value" <%if(item_nm.equals("�����̿�����")){%>onchange="county_change(this.selectedIndex);"<%}%>>
    			    <%if(item_nm.equals("�뵵����"))									{%>
                                <option value="1" <%if(base.getCar_st().equals("1")){%>selected<%}%>>��Ʈ</option>
                                <option value="3" <%if(base.getCar_st().equals("3")){%>selected<%}%>>����</option>
                                <option value="2" <%if(base.getCar_st().equals("2")){%>selected<%}%>>����</option>
                                <option value="5" <%if(base.getCar_st().equals("5")){%>selected<%}%>>�����뿩</option>
    			    <%}else if(item_nm.equals("��������"))								{%>
                                <option value='1' <%if(fee.getRent_way().equals("1")){%>selected<%}%>>�Ϲݽ�</option>
                                <option value='2' <%if(fee.getRent_way().equals("2")){%>selected<%}%>>�����</option>
                                <option value='3' <%if(fee.getRent_way().equals("3")){%>selected<%}%>>�⺻��</option>			  
    			    <%}else if(item_nm.equals("��������"))								{%>
                                <option value="1" <%if(base.getBus_st().equals("1")){%>selected<%}%>>���ͳ�</option>
                                <option value="8" <%if(base.getBus_st().equals("8")){%>selected<%}%>>�����</option>
                                <option value="5" <%if(base.getBus_st().equals("5")){%>selected<%}%>>��ȭ���</option>                                
                                <option value="2" <%if(base.getBus_st().equals("2")){%>selected<%}%>>�������</option>
                                <option value="7" <%if(base.getBus_st().equals("7")){%>selected<%}%>>������Ʈ</option>
                                <option value="6" <%if(base.getBus_st().equals("6")){%>selected<%}%>>������ü</option>
                                <option value="3" <%if(base.getBus_st().equals("3")){%>selected<%}%>>��ü�Ұ�</option>                                
                                <option value="4" <%if(base.getBus_st().equals("4")){%>selected<%}%>>catalog</option>
                                
    			    <%}else if(item_nm.equals("�����̿�����"))								{%>
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
    			    <%}else if(item_nm.equals("��������"))								{%>
                                <%if(brch_size > 0){
    					for (int i = 0 ; i < brch_size ; i++){
    						Hashtable branch = (Hashtable)branches.elementAt(i);%>
                                <option value='<%=branch.get("BR_ID")%>' <%if(cont_etc.getMng_br_id().equals(String.valueOf(branch.get("BR_ID")))){%> selected <%}%>><%= branch.get("BR_NM")%></option>
                                <%	}
    				}
    			         %>			  
    			    <%}%>	
                            </select>	
    			<%}%>	    			  
    			<%if(item_nm.equals("�����̿�����")){%>
    			    <select name='county'>
				<option value=''>��/��</option>
			    </select>   			  			  
                <%}%>	
                      								
    		    </td>			  
    		</tr>		
    		<tr>
    		    <td width="20%" class='title'>�������</td>
    		    <td>&nbsp;
    		        <input type='text' name='cng_cau' size='87' class='text' value='<%if(from_page.equals("/fms2/cooperation/cooperation_n2_sc.jsp")){%>ä���߽��Ƿڿ�û���� ����� ����<%}%>' style='IME-MODE: active'></td>			  
    		</tr>		
            </table>
        </td>
    </tr>	  
	  <%if(item_nm.equals("���������") && !base.getCar_st().equals("4")){%>
    <tr> 
        <td><input type='checkbox' name='with_reg' value='Y' checked> ��������ڿ� ���������� ���</td>
    </tr>
	  <%}%>
    <tr> 
        <td align="right">
            <%//if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
            <a href='javascript:save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
            <%//}%>
            <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
	  <%}%>
	  <%}%>
	  

	  <%if(vt_size2>1){%>		  
    <tr> 
        <td>* ���ϰŷ�ó�� ��������ڰ� <%=vt_size2%>�� �Դϴ�. </td>
    </tr>	
	  <%}%>	  
	  <%if(item_nm.equals("���������") && vt_size2>0){%>		
    <tr> 
        <td align="right" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="5%" class='title'>����</td>				
                    <td width="8%" class='title'>������ȣ </td>
                    <td width="12%" class='title'>�뿩�Ⱓ</td>
                    <td width="7%" class='title'>��������</td>					
                    <td width="4%" class='title'>����<br>����</td>
                    <td width="8%" class='title'>�����̿�����</td>					
                    <td width="25%" class='title' >����/����</td>
                    <td width="25%" class='title' >�����̿���</td>
                    <td width="6%" class='title' >����<br>�����</td>			  
                </tr>
				<%	Vector vt3 = a_db.getLcRentClientBusid2List(base.getClient_id());
					int vt_size3 = vt3.size();
    				for (int i = 0 ; i < vt_size3 ; i++){
    					Hashtable ht = (Hashtable)vt3.elementAt(i);%>
                <tr> 
                    <td align="center" <%if(String.valueOf(ht.get("USE_YN")).equals("N"))%>class=star<%%>><%=ht.get("RENT_ST")%></td>				
                    <td align="center" <%if(String.valueOf(ht.get("USE_YN")).equals("N"))%>class=star<%%>><%=ht.get("CAR_NO")%></td>
                    <td align="center" <%if(String.valueOf(ht.get("USE_YN")).equals("N"))%>class=star<%%>><%=ht.get("RENT_START_DT")%>~<%=ht.get("RENT_END_DT")%></td>									
                    <td align="center" <%if(String.valueOf(ht.get("USE_YN")).equals("N"))%>class=star<%%>><%=ht.get("CLS_DT")%></td>					
                    <td align="center" <%if(String.valueOf(ht.get("USE_YN")).equals("N"))%>class=star<%%>><%=ht.get("MNG_BR_ID")%></td>
                    <td align="center" <%if(String.valueOf(ht.get("USE_YN")).equals("N"))%>class=star<%%>><%=ht.get("EST_AREA")%> <%=ht.get("COUNTY")%></td>					
                    <td <%if(String.valueOf(ht.get("USE_YN")).equals("N"))%>class=star<%%>><%=ht.get("R_SITE")%><br><%=ht.get("ADDR")%></td>
                    <td <%if(String.valueOf(ht.get("USE_YN")).equals("N"))%>class=star<%%>><%=ht.get("COM_NM")%> <%=ht.get("MGR_DEPT")%> <%=ht.get("MGR_TITLE")%> <%=ht.get("MGR_NM")%>
					<%if(!String.valueOf(ht.get("MGR_ADDR")).equals("")){%><br>(�ּ�)<%=ht.get("MGR_ADDR")%><%}%>
					<%if(!String.valueOf(ht.get("MGR_EMAIL")).equals("") && !String.valueOf(ht.get("MGR_EMAIL")).equals("@")){%><br>(����)<%=ht.get("MGR_EMAIL")%><%}%>
					</td>
                    <td align="center" <%if(String.valueOf(ht.get("USE_YN")).equals("N"))%>class=star<%%>><%=ht.get("USER_NM")%></td>			  
                </tr>						
				<%	}%>		
            </table>
        </td>
    </tr>	  	
	  <%}%>
    <%if(item_nm.equals("��������")){%>	  
    <tr> 
        <td>* ���������� �����ϴ� ��쿡 �뿩���, �뿩��ݽ�����, �������-���������������������� �����ϼž� �մϴ�.</td>
    </tr>	    
    <%}%>
	  
</table>
<input type='hidden' name="c_st" 		value="<%=c_st%>">	
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
