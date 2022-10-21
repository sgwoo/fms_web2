<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*,  acar.receive.*, acar.credit.*, acar.cls.*"%>
<%@ page import="acar.cont.*, acar.user_mng.*, acar.doc_settle.*"%>
<%@ page import="acar.bill_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="re_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	
	String mode = request.getParameter("mode")==null?"5":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  
		
	CommonDataBase c_db = CommonDataBase.getInstance();	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "02");
	
		//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
//	if(base.getUse_yn().equals("Y"))	return;
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
				
	//��������
	ClsBean cls_info = ac_db.getClsCase(rent_mng_id, rent_l_cd);
	
	Hashtable fee_base = re_db.getClsContInfo(rent_mng_id, rent_l_cd);
	
	//rent_start_dt
	String  start_dt =  re_db.getRent_start_dt(rent_l_cd);
	
	int  days =  c_db.getDays(  AddUtil.getDate(4), cls_info.getCls_dt());
	
	//�߽�����
	ClsBandBean cls_band = re_db.getClsBandInfo(rent_mng_id, rent_l_cd);
		
	//ä��ȸ�� �� ��������������
	Vector vt_band = re_db.getClsBandEtcList(rent_mng_id, rent_l_cd);
	int vt_band_size = vt_band.size();
	
	String ven_code = "";
	String ven_name = "";
	
	Vector cms_bnk = c_db.getCmsBank();	//������� �����´�.
	int cms_bnk_size1 = cms_bnk.size();
	
	//����ä���� Ÿä��
	Vector vt_ext = ac_db.getClsList(base.getClient_id(), rent_l_cd);
	int vt_size = vt_ext.size();
	
	long total_amt	= 0;

	for(int i = 0 ; i < vt_size ; i++)
	{
		Hashtable ht = (Hashtable)vt_ext.elementAt(i);		
		total_amt = total_amt + AddUtil.parseLong(String.valueOf(ht.get("CLS_AMT")));		
	}	
		
	//����ǰ��  -  ä�ǰ��� doc_st : 9�ν���   ä���߽�:95 
	DocSettleBean doc = d_db.getDocSettleCommi("95", rent_l_cd);
	String doc_no = doc.getDoc_no();
	
	//�����
	user_bean 	= umd.getUsersBean(doc.getUser_id1());	
	
	//�Ҽ�����
	ClsSuitBean cls_suit = re_db.getClsSuitInfo(rent_mng_id, rent_l_cd);
	
	int draw_t = 0;
	int rate_t = 0;
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	
		//����ϱ�
	function  band_reg()	{
			
		var SUBWIN="/fms2/receive/rece_c7_i.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&c_id=<%=c_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>";	
		window.open(SUBWIN, "band_reg", "left=100, top=50, width=650, height=400, scrollbars=yes");
	}


		//�����û
	function sac_req(){
		var fm = document.form1;
		
		if(confirm('�����û�Ͻðڽ��ϱ�?')){					
			fm.action='receive_doc_sanction.jsp';		
			fm.target='i_no';
			fm.submit();
		}		
	}
	
	//����Ʈ
	function list(){
		var fm = document.form1;	

		fm.action = '<%=from_page%>';
		
		fm.target = 'd_content';
		fm.submit();
		
	}	
	
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
			
		// ��������� ��� �������� check
		if (doc_bit == '3' || doc_bit == '4' ) {	
			if(fm.settle_dt.value == '')				{ alert('�������ڸ� �Է��Ͻʽÿ�!!'); 		fm.settle_dt.focus(); 		return; }
		} else 	if (doc_bit == '1' || doc_bit == '2'  ) {	
				if(fm.settle_dt.value != '')				{ alert('�������ڸ� Ȯ���ϼ���!!'); 		fm.settle_dt.focus(); 		return; }	
		}
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='receive_doc_sanction.jsp';		
			fm.target='i_no';
			fm.submit();
		}									
	}
	
	//ä���߽� �Աݰ��� ����
	function band_sanction(doc_bit, seq){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
		fm.seq.value = seq;
					
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='receive_band_sanction.jsp';		
			fm.target='i_no';
			fm.submit();
		}									
	}
	
	
	//������ ����
	function sac_delete(doc_bit) {
		var fm = document.form1;
		
		fm.doc_bit.value = doc_bit;  
			
		if(confirm('�߽��Ƿڳ����� �����Ͻðڽ��ϱ�?')){	
			fm.action='receive_band_d_a.jsp';		
			fm.target='d_content';
			fm.submit();
		}	
		
	}	
			
	function save(){
		var fm = document.form1;
				
		if(fm.req_dt.value == '')				{ alert('û�����ڸ� �Է��Ͻʽÿ�'); 		fm.req_dt.focus(); 		return;	}				
	 	
		if ( ( toInt(parseDigit(fm.band_amt.value)) +  toInt(parseDigit(fm.no_re_amt.value)) )   !=   toInt(parseDigit(fm.tot_amt.value))  ) {	
	 		alert("�հ�ݾ��� Ȯ���ϼ���.!!");
			return; 	
	 	}			
			 	 				
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='receive_7_u_a.jsp';	

			fm.target='d_content';
			fm.submit();
		}		

	}
	
	//����ϱ�
	function  view_band(rent_mng_id, rent_l_cd , seq)	{
	
		window.open("/fms2/receive/rece_c7_u.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&seq="+seq, "band_reg", "left=100, top=50, width=650, height=400");
	
	}
	
	function update(){
		   var fm = document.form1;
			window.open("/fms2/receive/updateClsSeize.jsp?rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value, "CHANGE_ITEM", "left= 50, top=100, width=500, height=400");					
	
		
	}
	
	// �ڵ����
	function set_cls_amt(obj){
		var fm = document.form1;
											
		obj.value=parseDecimal(obj.value);
		if(obj == fm.band_amt || obj == fm.no_re_amt){ 
			fm.tot_amt.value 	= parseDecimal( toInt(parseDigit(fm.band_amt.value)) + toInt(parseDigit(fm.no_re_amt.value)) );				
		}	    	
	}
	
	

	//����ϱ�
function  viewSuit(){
		
	var SUBWIN="/fms2/receive/receive_6_u.jsp?cmd=view&ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&c_id=<%=c_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>";	
	window.open(SUBWIN, "band_reg", "left=100, top=50, width=1000, height=550, scrollbars=yes");
}

//-->
</script>
</head>
<body>

 <form  name="form1">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
<input type='hidden' name='rent_l_cd' value='<%=rent_l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='cmd' value='<%=cmd%>'>
<input type='hidden' name='go_url' value='<%=go_url%>'>  	
<input type='hidden' name="doc_bit" 		value="">   
<input type='hidden' name="doc_no" 		value="<%=doc_no%>">  
<input type='hidden' name="seq" > 
<input type='hidden' name="from_page"  value="<%=from_page%>" > 
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
  <tr> 
	    <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ä�ǰ��� > ä���߽ɰ��� > <span class=style5>ä���߽� ����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
        <tr>
        <td class=h></td>
    </tr>
    <tr>
	    <td align='right'> &nbsp;  &nbsp;&nbsp;<a href="javascript:list()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>
	    </td>
   </tr>
   
    <tr> 
        <td class=h></td>
    </tr>
    
 	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����⺻����</span></td>
	</tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>                              
                    <td width='12%' class='title' height="91">����ȣ</td>
                    <td height="17%">&nbsp;<%=fee_base.get("RENT_L_CD")%></td>
                    <td width='13%' class='title'>�����</td>
                    <td height="25%">&nbsp;������� : <%=c_db.getNameById((String)fee_base.get("BUS_ID2"),"USER")%> 
                      / ������� : <%=c_db.getNameById((String)fee_base.get("MNG_ID"),"USER")%></td>
                    <td width='12%' class='title'>�뿩���</td>
                    <td width='21%'>&nbsp; <%=fee_base.get("RENT_WAY")%></td>
                </tr>
                <tr> 
                    <td class='title'>��ȣ</td>
                    <td>&nbsp;<%=fee_base.get("FIRM_NM")%></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=fee_base.get("CLIENT_NM")%></td>
                    <td class='title'>�뿩����</td>
                    <td>&nbsp;<%=fee_base.get("CAR_NM")%>&nbsp;<%=fee_base.get("CAR_NAME")%></td>
                </tr>
                <tr> 
                    <td class='title'>������ȣ</td>
                    <td>&nbsp;<font color="#000099"><b><%=fee_base.get("CAR_NO")%></b></font></td>
                    <td class='title'>�����</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2((String)fee_base.get("INIT_REG_DT"))%></td>
                    <td class='title'>�뿩�Ⱓ</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(start_dt)%>&nbsp;~&nbsp;<%=cls_info.getCls_dt()%></td>
                </tr>
                <tr> 
                   <td class='title' height="91">��������</td>
                    <td >&nbsp;<%=cls_info.getCls_st()%> </td>                    
                    <td class='title'>������</td>
                    <td>&nbsp;<%=cls_info.getCls_dt()%>&nbsp;&nbsp; <font color="#000099"> (�������:  <%=days%>��  ) </font></td>
                    <td class='title'>���̿�Ⱓ</td>
                    <td>&nbsp;<%=cls_info.getRcon_mon()%>����&nbsp;<%=cls_info.getRcon_day()%>��</td>
              
                </tr>          
                <tr> 
                    <td class='title' style='height:40'>�������� </td>
                    <td colspan="5">
                        <table border="0" cellspacing="0" cellpadding="3" width=100%>
                            <tr>
                                <td><%=cls_info.getCls_cau()%> </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
       
    <tr></tr><tr></tr><tr></tr>  	  
        
  <tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ӳ���</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	
		    	    <tr>
		                    <td width="13%" class=title>��������</td>
		                    <td colspan=6>&nbsp;<input type='text' readonly  name='req_dt' value='<%=AddUtil.ChangeDate2(cls_band.getReq_dt())%>' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '></td> 		           
	                </tr>
	                <tr>
		                    <td width="13%" class=title>��������</td>
		                    <td colspan=6>&nbsp;<input type='text' name='settle_dt' value='<%=AddUtil.ChangeDate2(cls_band.getSettle_dt())%>' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '></td> 		           
	                </tr>
	                 <tr>
	                    <td width="13%" class=title>���Ӿ�ü��</td>
	                    <td colspan=4>&nbsp;
		            	<input name="n_ven_name" type="text" class="text" value="<%=cls_band.getN_ven_name()%>" size="35" style='IME-MODE: active' onKeyDown="javasript:search_enter(1)">
						&nbsp;&nbsp;&nbsp;* �׿����ڵ� : &nbsp;	        
				<input type="text" readonly name="n_ven_code" value="<%=cls_band.getN_ven_code()%>" class='whitetext' >
			      	<input type="hidden" name="n_ven_nm_cd"  value="">&nbsp;		
						<a href="javascript:search(1);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a> </td>				
		
	                    <td width="13%" class='title'>�߽ɼ�����(vat����)</td>
	                    <td>&nbsp;ȸ���ݾ��� <input type="text" name="re_rate" value="<%=cls_band.getRe_rate()%>" size="3" class=num>%</td>	             
	                </tr>
	                 <tr>
	                    <td width="13%" class=title>�μ���</td>
	                    <td width="20%">&nbsp;<input type="text" name="re_dept" value="<%=cls_band.getRe_dept()%>" size="25" class=text></td>
	                    <td width="10%" class='title' rowspan=2>�����</td>
	                    <td width="10%" class='title'>����</td>
	                    <td><input type="text" name="re_nm" value="<%=cls_band.getRe_nm()%>" size="25" class=text></td>	             
	                   <td width="13%" class='title'>fax</td>
	                    <td><input type="text" name="re_fax" value="<%=cls_band.getRe_fax()%>" size="25" class=text></td>	             
	                </tr>
	                 <tr>
	                    <td width="13%" class=title>��ǥ��ȭ</td>
	                    <td width="20%">&nbsp;<input type="text" name="re_tel" value="<%=cls_band.getRe_tel()%>" size="25" class=text></td>	            
	                    <td width="10%" class='title'>����ó</td>
	                    <td><input type="text" name="re_phone" value="<%=cls_band.getRe_phone()%>" size="25" class=text></td>	             
	                   <td width="13%" class='title'>�̸���</td>
	                    <td><input type="text" name="re_mail" value="<%=cls_band.getRe_mail()%>" size="25" class=text style='IME-MODE: inactive'></td>	             
	                </tr>     
	            
		       </table>
		      </td>        
         </tr>   
               
     	</table>
      </td>	 
    </tr>	 
        
    <tr></tr><tr></tr>
        <tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ŷ�����</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	
		    	 <tr>
		                    <td width="50%" class=title colspan=3>ä��ȸ���� �Աݰ���</td>
		                    <td width="50%" class=title colspan=3>�߽ɼ����� ���ް���</td>		                
	                </tr>
	                 <tr>
	                    <td width="15%" class=title>�����</td>
	                     <td width="15%" class=title>������</td>
	                     <td width="20%" class=title>���¹�ȣ</td>
	                      <td width="15%" class=title>�����</td>
	                      <td width="15%" class=title>������</td>
	                      <td width="20%" class=title>���¹�ȣ</td>	            
	                </tr>
	                   <tr>
	                      <td >&nbsp; <select name="bank_cd" style="width:135">
                            <option value="">==����==</option>                         
			     	 <% if(cms_bnk_size1 > 0){
						for(int i = 0 ; i < cms_bnk_size1 ; i++){
							Hashtable h_c_bnk = (Hashtable)cms_bnk.elementAt(i); %>  
						 <option value='<%=h_c_bnk.get("BCODE")%>' <%if(cls_band.getBank_cd().equals((String)h_c_bnk.get("BCODE"))){%>selected<%}%>><%= h_c_bnk.get("BNAME")%></option>
				                     
				              <%		}
							}%>
			      </select></td>	   	           
	                     <td width="15%">&nbsp;<input type="text" name="bank_nm" value="<%=cls_band.getBank_nm()%>" size="25" class=text></td>
	                     <td width="20%">&nbsp;<input type="text" name="bank_no" value="<%=cls_band.getBank_no()%>" size="25" class=text></td>
	                    <td >&nbsp; <select name="re_bank_cd" style="width:135">
                            <option value="">==����==</option>                         
			     	 <% if(cms_bnk_size1 > 0){
						for(int i = 0 ; i < cms_bnk_size1 ; i++){
							Hashtable h_c_bnk = (Hashtable)cms_bnk.elementAt(i); %>  
					     <option value='<%=h_c_bnk.get("BCODE")%>' <%if(cls_band.getRe_bank_cd().equals((String)h_c_bnk.get("BCODE"))){%>selected<%}%>><%= h_c_bnk.get("BNAME")%></option>
                     
				              <%		}
							}%>
			      </select></td>	             
	                      <td width="15%">&nbsp;<input type="text" name="re_bank_nm" value="<%=cls_band.getRe_bank_nm()%>" size="25" class=text></td>
	                      <td width="20%">&nbsp;<input type="text" name="re_bank_no" value="<%=cls_band.getRe_bank_no()%>" size="25" class=text></td>	            
	                </tr>         
	              
		       </table>
		      </td>        
         </tr>   
          <tr></tr><tr></tr>
          <tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����ä���� ����</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	
		    	 <tr>
		                     <td width="8%" class=title rowspan=3>ä��</td>
		                     <td width="10%" class=title >����ä��</td>
		                     <td colspan=3 >&nbsp;<input type="text" name="band_amt" value="<%=AddUtil.parseDecimal(cls_band.getBand_amt())%>" size="20" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>
		                     <td width="10%" class=title >��������</td>		                
		                     <td width="10%" ><input type="text" name="basic_dt" value="<%=AddUtil.ChangeDate2(cls_band.getBasic_dt())%>" size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '></td> 	       
	                  </tr>
	                	 <tr>
		                     <td width="10%" class=title >��ȸ���ڵ���</td>
		                     <td width="12%">&nbsp;<input type="text" name="no_re_amt" value="<%=AddUtil.parseDecimal(cls_band.getNo_re_amt())%>" size="20" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>
		                     <td width="10%" class=title >�ܰ�</td>		                
		                     <td width="10%" ><input type="text" name="car_jan_amt" value="<%=AddUtil.parseDecimal(cls_band.getCar_jan_amt())%>" size="15" class=num></td>	
		                     <td width="10%" class=title >�ܰ���������/����</td>	
		                     <td width="10%" >&nbsp;</td>		                
	                  </tr>
	                   <tr>
		                     <td width="10%" class=title >�հ�</td>
		                     <td width="12%">&nbsp;<input type="text" name="tot_amt" value="<%=AddUtil.parseDecimal(cls_band.getTot_amt())%>" size="20" class=num></td>
		                     <td width="13%" class=title >��ȸ���ڵ��������ӱ���</td>		                
		                     <td width="13%" >&nbsp;<input type="radio" name="re_st" value="1"  <%if(cls_band.getRe_st().equals("1"))%>checked<%%>>��������
	                            <input type="radio" name="re_st" value="2" <%if(cls_band.getRe_st().equals("2"))%>checked<%%>>����</td>	              
		                     <td  colspan=2>&nbsp;�հ�=����ä��+��ȸ���ڵ����� �ܰ�</td>		                
	                  </tr>
	                    <tr>
		                     <td width="13%" class=title  colspan=2 >����ä���� Ÿä��</td>
		                     <td width="12%" align=right ><%=vt_size%>��</td>		                                    
		                     <td width="10%" class=title >��ä�Ǳݾ�</td>	
		                     <td align=right><%=Util.parseDecimal(total_amt)%></td>	
		                     <td colspan=2>&nbsp;</td>			                
	                  </tr>
	              
		       </table>
		      </td>        
         </tr>   
           
     	 <tr>
     		 <td>&nbsp;</td>
     	 </tr>
     	</table>
      </td>	 
    </tr>	  	 	     	 	    
  
   <tr><td class=line2 colspan=2></td></tr> 
     <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
               <tr> 
	                    <td class=title> Ư�̻���</td>
	                    <td colspan="5" height="76"> 
	                     &nbsp;<textarea name="remarks" cols="140" rows="3"><%=cls_band.getRemarks()%></textarea>
	                  </td>
	           </tr>       
	          </table>        
         </td>
    </tr>            
    
    <tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�з�����
				  <%  if (  nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("ä�ǰ�����",user_id) || nm_db.getWorkAuthUser("ä�ǰ�����",user_id)  || nm_db.getWorkAuthUser("�������",user_id)    ){%>     
				  	 
				      <a href="javascript:update()"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
				  <% } %>
 	 		 </span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	
		    	    <tr>
		                   <td width="13%" class=title>�з�����</td>
		                   <td colspan=4>&nbsp;<input type='text'  name='seize_dt' value='<%=AddUtil.ChangeDate2(cls_band.getSeize_dt())%>' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '></td> 		           
		                   <td width="13%" class='title'>�з����</td>
		                   <td>&nbsp;<input type="text" name="seize_amt" value="<%=AddUtil.parseDecimal(cls_band.getSeize_amt())%>" size="15" class=num></td>	             
	                </tr>
	               	
		       </table>
		      </td>        
         </tr>   
          <tr>
     		 <td>&nbsp;</td>
     	 </tr>     
     	</table>
      </td>	 
    </tr>	
   
    <% if ( !cls_suit.getReq_dt().equals("") ) { %>
     <tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Ҽ��� ����				
				  	 
				      <a href="javascript:viewSuit()"><img src=/acar/images/center/button_see.gif align=absmiddle border=0></a>
			
 	 		 </span></td>
 	 	  </tr>
 	 	   
          <tr>
     		 <td>&nbsp;</td>
     	 </tr>     
     	</table>
      </td>	 
    </tr>	
   <% }  %> 
        <tr></tr><tr></tr>
          <tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ä��ȸ�� �� ����������</span></td>
 	 		 <td align="right">
 	 		 <% if ( cls_band.getSettle_dt().equals("") && !doc_no.equals("") ) {%>
 	 		 <a href='javascript:band_reg()'><img src=/acar/images/center/button_plus.gif border=0 align=absmiddle></a>
 	 		 <% } %>
 	 		 </td>
 	 	  </tr>
 	 	  <tr>
      		 <td colspan=2 class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	<td colspan=2  class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	
		    		 <tr>
	                     <td width="8%" class=title rowspan=2>����</td>
	                     <td width="32%" class=title colspan=3 >�Ա�(ȸ���ݾ�)</td>
	                     <td width="32%" class=title colspan=3 >����(�߽ɼ�����)</td>		
	                     <td width="28%" class=title colspan=3 >����</td>		                
	                 </tr>
                	 <tr>
	                     <td width="10%" class=title >����</td>	
	                     <td width="10%" class=title >�ݾ�</td>			                   
	                     <td width="10%" class=title >�Ա�����</td>		                
	           	         <td width="10%" class=title >����</td>	
	                     <td width="10%" class=title >�ݾ�</td>			                   
	                     <td width="10%" class=title >��������</td>
	                     <td width="14%" class=title >���</td>			                   
	                     <td width="14%" class=title >�ѹ�����</td>			                                    
                    </tr>	       
 <%		for(int i = 0 ; i < vt_band_size ; i++)
		{
			Hashtable ht = (Hashtable)vt_band.elementAt(i);
			draw_t +=  AddUtil.parseInt((String)ht.get("DRAW_AMT"));	
			rate_t +=  AddUtil.parseInt((String)ht.get("RATE_AMT"));	
			
%>
					<tr>
						<td  width='8%' align='center'>				
					   <a href="javascript:view_band( '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>' , '<%=ht.get("SEQ")%>');"><%=i+1%></a>
						</td>		
						<td  width='10%' align='center'><%if(String.valueOf(ht.get("BAND_ST")).equals("1")) {%>�κ��Ա�<%}else{%>����<%}%></td>		
						<td  width='10%' align='right'><%=AddUtil.parseDecimal(ht.get("DRAW_AMT"))%></td>
						<td  width='10%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("BAND_IP_DT")))%></td>
						<td  width='10%'  align='center'>&nbsp���޼�����</td>			
						<td  width='10%' align='right'><%=AddUtil.parseDecimal(ht.get("RATE_AMT"))%></td>
						<td  width='10%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RATE_JP_DT")))%></td>	
						<td  width='14%' align='center'><font color="#999999"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID1")),"USER_PO")%><br><%=String.valueOf(ht.get("USER_DT1"))%><%if(String.valueOf(ht.get("USER_DT1")).equals("")){%><br><a href="javascript:band_sanction('1', '<%=String.valueOf(ht.get("SEQ"))%>');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a> <%}%></font></td>
						<td  width='14%' align='center'><font color="#999999"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID2")),"USER_PO")%><br><%=String.valueOf(ht.get("USER_DT2"))%><%if(!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT2")).equals("")){%><%if(String.valueOf(ht.get("USER_ID2")).equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�ӿ�",user_id) ){%><br><a href="javascript:band_sanction('2', '<%=String.valueOf(ht.get("SEQ"))%>')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a><%}%><%}%></font></td>	
					</tr>

<%  } %>	
        <% if ( vt_band_size > 0 ) { %>		                  
	   	           <tr>
	                     <td  align='center'>&nbsp;</td>
	                     <td  align='center'>�Ա� �հ�</td>	
	                     <td width="10%" align='right'><%=AddUtil.parseDecimal(draw_t)%></td>			                   
	                     <td align='center'>&nbsp;</td> 
	                     <td align='center'>���޼����� �հ�</td> 
	                     <td width="10%" align='right' ><%=AddUtil.parseDecimal(rate_t)%></td>			                   
	                     <td align='center' >ä�� �ܾ� :
						<%if ( (cls_band.getTot_amt() - draw_t) < 0) {%>0<% } else {%><%=AddUtil.parseDecimal(cls_band.getTot_amt() - draw_t)%><%} %></td>
	                     <td colspan=2 align='center' >&nbsp;</td>
	                 
	                 	                                    
                    </tr>
         <%  } %>           	                                   
		       </table>
		      </td>        
         		</tr>              		
           		
     	 	<tr>
     		 <td>&nbsp;</td>
     		 </tr>
     	         		 
     	 <%if( auth_rw.equals("4")||auth_rw.equals("6") ){%>  	 	      	 
     		     
	    	  <tr>
			    <td align='center'>			  	
			   <%	if(  nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("ä�ǰ�����",user_id)    ) {%>
			       <% if(  doc.getUser_dt1().equals("") ) {%>
			         <a href="javascript:sac_req();"><img src=/acar/images/center/button_gjyc.gif align=absmiddle border=0></a>&nbsp;	
			         <a href="javascript:sac_delete('0');"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>&nbsp;   
				   <%}%> 	
			         <a href="javascript:save();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp; 	
			   <%}%> 
			    </td>
			</tr>			  
	   	<%}%>
	   	       
	    <% if(  !doc.getUser_dt1().equals("") ) {%>
	   <tr> 
	        <td class=line colspan="2"> 
	            <table border="0" cellspacing="1" width=100%>
	           		<tr>
	                    <td class=title width=10% rowspan="3">����</td>
	                    <td colspan="2" width=20% class='title'>����</td>
					    <td colspan="2" width=20% class='title'>���</td>	
					    <td class=title width=50% rowspan="2">-</td>                  
	                </tr>
	                <tr>					 
					  <td width='100' class='title'>���</td>
					  <td width='100' class='title'>�ѹ�����</td>					
					  <td width='100' class='title'>���</td>
					  <td width='100' class='title'>�ѹ�����</td>					
				    </tr>
	                <tr>
	                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%><%if(doc.getUser_dt1().equals("")){%><br><a href="javascript:doc_sanction('1');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a> <%}%></font></td>
	                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%><%if(!doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("")){%><%if(doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�ӿ�",user_id) ){%><br><a href="javascript:doc_sanction('2')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a><%}%><%}%></font></td>
	                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%><%if(!doc.getUser_dt2().equals("") && doc.getUser_dt3().equals("")){%><%if(doc.getUser_id3().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�ӿ�",user_id) ){%><br><a href="javascript:doc_sanction('3')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a><%}%><%}%></font></td>
	                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id4(),"USER_PO")%><br><%=doc.getUser_dt4()%><%if(!doc.getUser_dt3().equals("") && doc.getUser_dt4().equals("")){%><%if(doc.getUser_id4().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�ӿ�",user_id) ){%><br><a href="javascript:doc_sanction('4')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a><%}%><%}%></font></td>
	               		<td align="center"></td>
	                </tr> 
	            </table>
		    </td>
	    </tr>
	 <% } %> 
     		 
     		 
     	</table>
      </td>	 
    </tr>	  	 	     	 	    
        

  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>

</script>
</body>
</html>
