<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*,acar.client.*,acar.common.*, acar.user_mng.*, acar.settle_acc.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String rent_st  	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String cmd	  		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String c_st = "";
	
	if(from_page.equals("/agent/cooperation/cooperation_n2_sc.jsp")){
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
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();
	
	//�����Ҹ���Ʈ
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();
	
	Vector vt = a_db.getLcRentCngHList(rent_mng_id, rent_l_cd, cng_item);
	int vt_size = vt.size();
	
	String item_nm = "";
	if(cng_item.equals("bus_id2")) 		item_nm = "���������";
	if(cng_item.equals("mng_id")) 		item_nm = "���������";
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
	
	Vector vt2 = new Vector();
	//����������� ��� ���ϰŷ�ó�� ��������ڰ� �������϶� ����Ʈ Ȯ��
	if(cng_item.equals("bus_id2")){
		vt2 = a_db.getLcRentClientBusid2(base.getClient_id());
	}
	int vt_size2 = vt2.size();
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
		
		<%if(item_nm.equals("���������")||item_nm.equals("���������")){%>
		if(fm.new_value.value.substring(0,1) == '1')	{ alert('�μ��� ���õǾ����ϴ�. Ȯ�����ּ���.'); return; }
		<%}%>

		if(fm.cng_cau.value == ""){			alert("��������� �Է��� �ּ���!");		fm.cng_cau.focus();		return;	}
		
		if(!confirm("�����Ͻðڽ��ϱ�?"))	return;
		fm.target = "i_no";
		fm.submit();
	}
	
	<%if(item_nm.equals("������")||item_nm.equals("������")||item_nm.equals("���ô뿩��")||item_nm.equals("�뿩��")||item_nm.equals("����뿩��")){%>
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
  
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
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
    			    <%if(item_nm.equals("���������") || item_nm.equals("���������"))	{%><%=c_db.getNameById(old_value, "USER")%>
    				<%}else if(item_nm.equals("�뵵����"))								{%><%if(old_value.equals("1")){%>��Ʈ<%  }else if(old_value.equals("2")){%>����<%  }else if(old_value.equals("3")){%>����<%}%>
    				<%}else if(item_nm.equals("��������"))								{%><%if(old_value.equals("1")){%>�Ϲݽ�<%}else if(old_value.equals("3")){%>�⺻��<%}%>
    				<%}else if(item_nm.equals("��������"))								{%><%=c_db.getNameById(old_value,"BRCH")%>
    				<%}else if(item_nm.equals("������") || item_nm.equals("������") || item_nm.equals("���ô뿩��") || item_nm.equals("�뿩��")||item_nm.equals("����뿩��")){%><%=AddUtil.parseDecimal(AddUtil.replace(old_value,",",""))%>
					<%}else if(item_nm.equals("��������"))								{%><%if(old_value.equals("1")){%>���ͳ�<%}else if(old_value.equals("2")){%>�������<%}else if(old_value.equals("3")){%>��ü�Ұ�<%}else if(old_value.equals("4")){%>catalog<%}else if(old_value.equals("5")){%>��ȭ���<%}else if(old_value.equals("6")){%>������ü<%}%>
    				<%}else if(item_nm.equals("�����̿�����"))							{%><%=old_value%>
    				<%}%>
    			    </td>
                    <td align="center">
    			    <%if(item_nm.equals("���������") || item_nm.equals("���������"))	{%><%=c_db.getNameById(new_value, "USER")%>
    				<%}else if(item_nm.equals("�뵵����"))								{%><%if(new_value.equals("1")){%>��Ʈ<%  }else if(new_value.equals("2")){%>����<%  }else if(new_value.equals("3")){%>����<%}%>
    				<%}else if(item_nm.equals("��������"))								{%><%if(new_value.equals("1")){%>�Ϲݽ�<%}else if(new_value.equals("3")){%>�⺻��<%}%>
    				<%}else if(item_nm.equals("��������"))								{%><%=c_db.getNameById(new_value,"BRCH")%>
    				<%}else if(item_nm.equals("������") || item_nm.equals("������") || item_nm.equals("���ô뿩��") || item_nm.equals("�뿩��")||item_nm.equals("����뿩��")){%><%=AddUtil.parseDecimal(AddUtil.replace(new_value,",",""))%>
					<%}else if(item_nm.equals("��������"))								{%><%if(new_value.equals("1")){%>���ͳ�<%}else if(new_value.equals("2")){%>�������<%}else if(new_value.equals("3")){%>��ü�Ұ�<%}else if(new_value.equals("4")){%>catalog<%}else if(new_value.equals("5")){%>��ȭ���<%}else if(new_value.equals("6")){%>������ü<%}%>
    				<%}else if(item_nm.equals("�����̿�����"))							{%><%=new_value%>
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
    			<%  }
    			}%>		
            </table>
        </td>
    </tr>
	  <%if(!cmd.equals("view") && !item_nm.equals("����뿩��")){%>
	  <%String cng_auth = "";%>
	  
	  <%if(item_nm.equals("���������")||item_nm.equals("���������")||item_nm.equals("��������")){ 		if(nm_db.getWorkAuthUser("��������ں���",ck_acar_id))	{ 	cng_auth = "r"; }}%>
		
	  <%if(item_nm.equals("�����̿�����")){ 																if(base.getBus_id().equals(ck_acar_id) || base.getBus_id2().equals(ck_acar_id) || nm_db.getWorkAuthUser("��������ں���",ck_acar_id))	{ 	cng_auth = "r"; }}%>
		
	  <%if(item_nm.equals("�뵵����")||item_nm.equals("��������")||item_nm.equals("��������")){ 			if(nm_db.getWorkAuthUser("�뿩��ĺ���",  ck_acar_id))	{ 	cng_auth = "r"; }}%>
		
	  <%if(item_nm.equals("������")||item_nm.equals("������")||item_nm.equals("���ô뿩��")
	       ||item_nm.equals("�뿩��")||item_nm.equals("����뿩��")){ 										if(nm_db.getWorkAuthUser("ȸ�����",      ck_acar_id))	{ 	cng_auth = "r"; c_st = "fee";}}%>
	  
	  <%if((cmd.equals("�Աݼ����� ����")||cmd.equals("�ſ��յ���� �Աݼ����� ����")) && (item_nm.equals("������")||item_nm.equals("������")||item_nm.equals("���ô뿩��"))){ 		cng_auth = "r"; c_st = "fee";}%>     	  
		
		
	  <%if(cng_auth.equals("r")){%>	  
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
    			  <%String old_value2 = "";%>
    			  <%if(item_nm.equals("���������")){
    			    	old_value2 = base.getBus_id2();%>
    			    <%=c_db.getNameById(old_value2,"USER")%>
    			  <%}else if(item_nm.equals("���������")){
    			    	old_value2 = base.getMng_id();%>
    			    <%=c_db.getNameById(old_value2,"USER")%>
    			  <%}else if(item_nm.equals("�뵵����")){
    			    	old_value2 = base.getCar_st();%>
    			    <%if(old_value2.equals("1")){%>��Ʈ<%  }else if(old_value2.equals("2")) {%>����<%  }else if(old_value2.equals("3")){%>����<%}%>
    			  <%}else if(item_nm.equals("��������")){
    			    	old_value2 = fee.getRent_way();%>
    			    <%if(old_value2.equals("1")){%>�Ϲݽ�<%}else if(old_value2.equals("3")){%>�⺻��<%}%>
    			  <%}else if(item_nm.equals("��������")){
    			    	old_value2 = base.getBus_st();%>
    			    <%if(old_value2.equals("1")){%>���ͳ�<%}else if(old_value2.equals("2")){%>�������<%}else if(old_value2.equals("3")){%>��ü�Ұ�<%}else if(old_value2.equals("4")){%>catalog<%}else if(old_value2.equals("5")){%>��ȭ���<%}else if(old_value2.equals("6")){%>������ü<%}%>
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
    			  <%}%>			  
    			    <input type='hidden' name="old_value" value="<%=old_value2%>">				  
    			    </td>			  
    			</tr>		
    		    <tr>
    			    <td width="20%" class='title'>������</td>
    			    <td>&nbsp;
    			  <%if(item_nm.equals("������")||item_nm.equals("������")||item_nm.equals("���ô뿩��")||item_nm.equals("�뿩��")||item_nm.equals("����뿩��")){%>
    			    <input type='text' name='new_value' size='12' class='num' value="" onBlur='javascript:this.value=parseDecimal(this.value);set_amt();'>��
    			    &nbsp;&nbsp;&nbsp;&nbsp;
    			  ( ���ް� : <input type='text' name='s_amt' size='10' class='num' value="" onBlur='javascript:this.value=parseDecimal(this.value);'>�� / �ΰ��� : <input type='text' name='v_amt' size='10' class='num' value="" onBlur='javascript:this.value=parseDecimal(this.value);'>�� )
    			  
    			  <%}else{%>
                    <select name="new_value" <%if(item_nm.equals("�����̿�����")){%>onchange="county_change(this.selectedIndex);"<%}%>>
    			  <%if(item_nm.equals("���������"))									{%>
                    <%for(int i = 0 ; i < user_size ; i++){
    						Hashtable user = (Hashtable)users.elementAt(i); 
							if(from_page.equals("/agent/cooperation/cooperation_n2_sc.jsp")){
								base.setBus_id2("000144");
							}%>
                    <option value='<%=user.get("USER_ID")%>' <%if(base.getBus_id2().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                    <%}%>
    			  <%}else if(item_nm.equals("���������"))								{%>
                    <%for(int i = 0 ; i < user_size ; i++){
    						Hashtable user = (Hashtable)users.elementAt(i); 
    					%>
                    <option value='<%=user.get("USER_ID")%>' <%if(base.getMng_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                    <%}%>
    			  <%}else if(item_nm.equals("�뵵����"))								{%>
                    <option value="1" <%if(base.getCar_st().equals("1")){%>selected<%}%>>��Ʈ</option>
                    <option value="3" <%if(base.getCar_st().equals("3")){%>selected<%}%>>����</option>
                    <option value="2" <%if(base.getCar_st().equals("2")){%>selected<%}%>>����</option>			  
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
                    
    			  <%}else if(item_nm.equals("�����̿�����"))							{%>
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
                  <%	if(brch_size > 0)	{
    						for (int i = 0 ; i < brch_size ; i++){
    							Hashtable branch = (Hashtable)branches.elementAt(i);%>
                  <option value='<%=branch.get("BR_ID")%>' <%if(cont_etc.getMng_br_id().equals(String.valueOf(branch.get("BR_ID")))){%> selected <%}%>><%= branch.get("BR_NM")%></option>
                  <%		}
    					}%>			  
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
    			        <input type='text' name='cng_cau' size='87' class='text' value='<%if(from_page.equals("/agent/cooperation/cooperation_n2_sc.jsp")){%>ä���߽��Ƿڿ�û���� ����� ����<%}%>' style='IME-MODE: active'></td>			  
    			</tr>		
            </table>
        </td>
    </tr>	  
	  <%if(item_nm.equals("���������")){%>
    <tr> 
        <td><input type='checkbox' name='with_reg' value='Y' checked> ��������ڿ� ���������� ���</td>
    </tr>
	  <%}%>
    <tr> 
        <td align="right"><a href='javascript:save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
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
                    <td align="center" <%if(String.valueOf(ht.get("USE_YN")).equals("N"))%>class=star<%%>><%=ht.get("EST_AREA")%></td>					
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
	  
</table>
<input type='hidden' name="c_st" 		value="<%=c_st%>">	
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
