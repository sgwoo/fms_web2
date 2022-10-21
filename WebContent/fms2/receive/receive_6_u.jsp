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
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
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
		
	//if(base.getUse_yn().equals("Y"))	return;
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
				
	//��������
	ClsBean cls_info = ac_db.getClsCase(rent_mng_id, rent_l_cd);
	
	Hashtable fee_base = re_db.getClsContInfo(rent_mng_id, rent_l_cd);
	
	//rent_start_dt
	String  start_dt =  re_db.getRent_start_dt(rent_l_cd);
	
	int  days =  c_db.getDays(  AddUtil.getDate(4), cls_info.getCls_dt());
	
	//�߽�����
	ClsBandBean cls_band = re_db.getClsBandInfo(rent_mng_id, rent_l_cd);
			
	long total_amt1	= 0;
	long total_amt2	= 0;
	long total_amt3	= 0;
	
	//����ǰ��  -  ä�ǰ��� doc_st : 9�ν���   ä�ǼҼ�:96 
	DocSettleBean doc = d_db.getDocSettleCommi("96", rent_l_cd);
	String doc_no = doc.getDoc_no();
	
	//�����
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	//�Ҽ�����
	ClsSuitBean cls_suit = re_db.getClsSuitInfo(rent_mng_id, rent_l_cd);
	
	int size = 0;
	
	String content_code = "RECEIVE";
	String content_seq  = rent_mng_id+""+rent_l_cd;

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;	
	
	//���� ����üũ	
 	content_seq  = rent_mng_id+""+rent_l_cd+"1";
	 attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	 int attach2_vt_size =  attach_vt.size();	
 
  //�ǰṮ  ��� üũ	
 	content_seq  = rent_mng_id+""+rent_l_cd+"2";
	 attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	 int attach4_vt_size =  attach_vt.size();	
		
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	
		//�����û
	function sac_req(){
		var fm = document.form1;
		
		if(confirm('�����û�Ͻðڽ��ϱ�?')){					
			fm.action='receive_suit_sanction.jsp';		
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
				
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='receive_suit_sanction.jsp';		
			fm.target='i_no';
			fm.submit();
		}									
	}
	
	//��ĵ���
	function scan_reg(gubun){
		window.open("reg_scan.jsp?gubun="+gubun+"&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//��ĵ����
	function scan_del(gubun){
		var theForm = document.form1;
		if(!confirm('�����Ͻðڽ��ϱ�?')){		return;	}
		theForm.target = "i_no"
		theForm.action = "del_scan_a.jsp?gubun="+gubun;
		theForm.submit();
	}
	

	//������ ����
	function sac_delete(doc_bit) {
		var fm = document.form1;
		
		fm.doc_bit.value = doc_bit;  
			
		if(confirm('�Ҽ��Ƿڳ����� �����Ͻðڽ��ϱ�?')){	
			fm.action='receive_suit_d_a.jsp';		
			fm.target='d_content';
			fm.submit();
		}	
		
	}	
			
	function save(){
		var fm = document.form1;
		
		if(fm.req_dt.value == '')				{ alert('�Ҽ����ڸ� �Է��Ͻʽÿ�'); 		fm.req_dt.focus(); 		return;	}
		if (toInt(parseDigit(fm.suit_amt.value)) < 1 )				{ alert('�Ҽ۱ݾ��� �Է��Ͻʽÿ�'); 		fm.suit_amt.focus(); 		return;	}
		if (fm.s_type.value == '' )				{ alert('�Ҽ������� �����Ͻʽÿ�'); 		fm.s_type.focus(); 		return;	}		
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='receive_6_u_a.jsp';	
//			fm.target='ii_no';
			fm.target='d_content';
			fm.submit();
		}		

	}
	
	//���꼭 �μ�
	function cls_print(){
		var fm = document.form1;

		var SUBWIN="/fms2/cls_cont/lc_cls_print.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>";
		window.open(SUBWIN, "clsPrint", "left=100, top=10, width=700, height=650, resizable=yes, scrollbars=yes, status=yes");
		
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
<input type='hidden' name="from_page"  value="<%=from_page%>" > 
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
  <tr> 
	    <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ä�ǰ��� > ä���߽ɰ��� > <span class=style5>ä�ǼҼ� ����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
        <tr>
        <td class=h></td>
    </tr>
    <tr>
	    <td align='right'> &nbsp;&nbsp;&nbsp;
	    <% if ( !cmd.equals("view")) { %>
	        <a href="javascript:list()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>
	    <% } %>    
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
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Ҽ۳���</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	
		    	    <tr>
		                    <td width="10%" class=title>�Ҽ�����</td>
		                    <td colspan=6>&nbsp;<input type='text' name='req_dt' value='<%=AddUtil.ChangeDate2(cls_suit.getReq_dt())%>' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '></td> 		           
	                </tr>
	                <tr> 
	                    <td class=title width=9%>�Ҽ�����</td>
	                    <td colspan=5 >&nbsp;
	                    <input type="radio" name="s_type" value="1" <%if(cls_suit.getS_type().equals("1")){%>checked<%}%>>����������������ȸ
						<input type="radio" name="s_type" value="2" <%if(cls_suit.getS_type().equals("2")){%>checked<%}%>>�λ�Ҽ�
						<input type="radio" name="s_type" value="N" <%if(cls_suit.getS_type().equals("N")){%>checked<%}%>>�ҼۺҰ�
	                    </td>                  
	              	  </tr>
	              	  <tr>
	                     <td class=title>������</td>
	                     <td >&nbsp;<input type="text" name="suit_dt" size="11" value='<%=AddUtil.ChangeDate2(cls_suit.getSuit_dt())%>'  class=text  onBlur='javscript:this.value = ChangeDate(this.value);'></td>
	                     <td class=title>������ȣ</td>
	                     <td colspan=3 > &nbsp;<input type="text" name="suit_no" size="20" class=text value='<%=cls_suit.getSuit_no()%>'  ></td>
	                 	</tr>
	                   <tr>     
	                    <td class=title width=9%>�Ҽ۱ݾ�</td>
	                    <td >&nbsp;<input type="text" name="suit_amt"  size="11" value='<%=AddUtil.parseDecimal(cls_suit.getSuit_amt())%>'  class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
	                    &nbsp;&nbsp;<a href='javascript:cls_print();' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_print_jss.gif align=absmiddle border=0></a>
	                    </td>
	                    <td class=title width=9%>�Ҽۺ��</td>
	                    <td colspan=3 >&nbsp;<input type="text" name="amt1" value='<%=AddUtil.parseDecimal(cls_suit.getAmt1())%>'  size="11" class=num onBlur='javascript:this.value=parseDecimal(this.value);'></td>
	                   
	                   </tr>
		                <tr> 
	                    <td class=title> Ư�̻���</td>
	                    <td colspan="5" height="76"> 
	                     &nbsp;<textarea name="req_rem" cols="140" rows="3"><%=cls_suit.getReq_rem()%></textarea>
	                    </td>
	                   </tr>
		       </table>
		      </td>        
         </tr>   
               
     	</table>
      </td>	 
    </tr>	
    <tr><td class=h></td></tr>
    <tr><td class=line2 colspan=2></td></tr> 
     <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
               <tr> 
					 <td class=title width=10%>�ǰ���</td>
                     <td colspan="5">
                      &nbsp;<input type="text" name="mean_dt" value="<%=AddUtil.ChangeDate2(cls_suit.getMean_dt())%>" size="11" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>   
                <tr> 
	                    <td class=title> ����</td>
	                    <td colspan="5" height="76"> 
	                     &nbsp;<textarea name="Suit_rem" cols="140" rows="3"><%=cls_suit.getSuit_rem()%></textarea>
	                    </td>
                </tr> 
                <tr>
                 <td align='center' class='title'  width=10% >����</td>
                 <td>
                <%
                 	content_seq  = rent_mng_id+""+rent_l_cd+"1";
                 	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
                 	attach_vt_size = attach_vt.size();	
                 %>
                 		<%if(attach_vt_size > 0){   %>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);
    						%>
    						 <%if(attach_ht.get("FILE_TYPE").equals("image/jpeg")||attach_ht.get("FILE_TYPE").equals("image/pjpeg")||attach_ht.get("FILE_TYPE").equals("application/pdf")){%>			
							 <a href="javascript:openPopF('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='����' ><%=attach_ht.get("FILE_NAME")%></a>
							 <%}else{%>
							 <a href="https://fms3.amazoncar.co.kr/fms2/attach/download.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><%=attach_ht.get("FILE_NAME")%></a>
							 <%}%> 
    						&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}else{%>			
    						&nbsp;<a href="javascript:scan_reg('1')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
    						<%}%>
            	  </td>
            	  <td align='center' class='title'  width=10% >�ǰṮ</td>
                 <td>
                <%
                 	content_seq  = rent_mng_id+""+rent_l_cd+"2";
                 	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
                 	attach_vt_size = attach_vt.size();	
                 %>
                 				<%if(attach_vt_size > 0){   %>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);
    						%>
	    						<%if(attach_ht.get("FILE_TYPE").equals("image/jpeg")||attach_ht.get("FILE_TYPE").equals("image/pjpeg")||attach_ht.get("FILE_TYPE").equals("application/pdf")){%>			
								 <a href="javascript:openPopF('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='����' ><%=attach_ht.get("FILE_NAME")%></a>
								 <%}else{%>
								 <a href="https://fms3.amazoncar.co.kr/fms2/attach/download.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><%=attach_ht.get("FILE_NAME")%></a>
								 <%}%> 							    							
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}else{%>			
    						&nbsp;<a href="javascript:scan_reg('2')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
    						<%}%>
            	  </td>
				</tr>
						
            </table>
        </td>
    <tr>
                   
    <tr>
     	 <td>&nbsp;</td>
     </tr>
  
  <% if ( !cmd.equals("view") ) { %>    
      <%if(auth_rw.equals("4")||auth_rw.equals("6")){%>  	 	      	 
     		     
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
					    <td class=title width=50% rowspan="2">-</td>                  
	                </tr>
	                <tr>					 
					  <td width='100' class='title'>���</td>
					  <td width='100' class='title'>�ѹ�����</td>				
						
				    </tr>
	                <tr>
	                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%><%if(doc.getUser_dt1().equals("")){%><br><a href="javascript:doc_sanction('1');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a> <%}%></font></td>
	                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%><%if(!doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("")){%><%if(doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�ӿ�",user_id) ){%><br><a href="javascript:doc_sanction('2')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a><%}%><%}%></font></td>
	                 	<td align="center"></td>
	                </tr> 
	            </table>
		    </td>
	    </tr>
	 <% } %> 
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
