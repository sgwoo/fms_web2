<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.receive.*, acar.doc_settle.*, acar.car_office.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.user_mng.*,   acar.cls.*"%>
<%@ page import="acar.bill_mng.* "%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="rc_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 
<%@ include file="/acar/access_log.jsp" %>


<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "08", "10");	
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	
	
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	if(base.getUse_yn().equals("Y"))	return;
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());		
		
	//��������
	ClsBean cls_info = ac_db.getClsCase(rent_mng_id, rent_l_cd);
	
	Hashtable fee_base = rc_db.getClsContInfo(rent_mng_id, rent_l_cd);
	
	//rent_start_dt
	String  start_dt =  rc_db.getRent_start_dt(rent_l_cd);
	
	int  days =  c_db.getDays(  AddUtil.getDate(4), cls_info.getCls_dt());
	
	
	String ven_code = "";
	String ven_name = "";
	
	Vector cms_bnk = c_db.getCmsBank();	//������� �����´�.
	int cms_bnk_size1 = cms_bnk.size();
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//���ຸ������
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd,  Integer.toString(fee_size));
		
	//��������û������
	ClsGuarBean carGur = rc_db.getClsGuarInfo(rent_mng_id, rent_l_cd);
	
	int req_i_amt = 0;
	if (carGur.getIp_amt() > 0 ) {
			req_i_amt = carGur.getReq_amt() - carGur.getIp_amt();
	} 
		
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	

	//�ݱ� 
	function list(){
		self.close();
		window.close();
	}	
	
	function save(){  //û��/  �Աݳ��� ���(����) 
		var fm = document.form1;
	
		if(fm.ip_dt.value == "")		{ 	alert("�Ա����� �Է��Ͻʽÿ�."); 		fm.req_dt.focus(); 		return;		}
		if(fm.ip_amt.value == "")		{ 	alert("�Աݾ��� �Է��Ͻʽÿ�."); 		fm.req_amt.focus(); 		return;		}
			
		if(fm.bank_nm.value == ""){ alert("������ �����Ͻʽÿ�."); return; }			
		if(fm.bank_no.value == ""){ alert("���¹�ȣ�� �Է��Ͻʽÿ�."); return; }				
				
		//�����Է�
		if ( toInt(parseDigit(fm.req_i_amt.value))  >0 ) {
			if(fm.remark.value == ""){				
			 		alert("û���ݾ״�� ������ �߻��� ������ �Է��ϼ���.!!");			     	return;			
			} 		
		}									
		 
		if(confirm('����Ͻðڽ��ϱ�?')){		
			fm.action='gua_u_a.jsp';
			fm.target='i_no';
//			fm.target='d_content';
			fm.submit();
		}		
	}	
	
	
	// �ڵ����
	function set_cls_amt(obj){
	
		var fm = document.form1;
			
		obj.value=parseDecimal(obj.value);
		
			
		if(obj == fm.ip_amt){ //�Աݾ�
			if(fm.ip_amt.value != '0'){		
				fm.req_i_amt.value 	= parseDecimal( toInt(parseDigit(fm.req_amt.value)) - toInt(parseDigit(fm.ip_amt.value)) );				
			}
		}	
	}
	
	
	//���
	function doc_del(){
		var fm = document.form1;
										
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}	
		fm.cmd.value = "D";
		fm.action = "gua_u_a.jsp";		
		fm.target = "i_no";
		fm.submit()
		
	}
		
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='' name="form1" method='post'>
 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>
 <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
<input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
<input type='hidden' name='cmd' >

<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	 <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;ä�ǰ��� >����������� > <span class=style1><span class=style5>�������� ����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	    <td align='right'> &nbsp; &nbsp;&nbsp;<a href="javascript:list()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
	    </td>
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
                    <td colspan="3">
                        <table border="0" cellspacing="0" cellpadding="3" width=100%>
                            <tr>
                                <td><%=cls_info.getCls_cau()%> </td>
                            </tr>
                        </table>
                    </td>
                       <td class='title'>���������</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(cls_info.getFdft_amt2())%>��</td>
                </tr>
            </table>
        </td>
    </tr>
    
    <tr>
        <td class=h></td>
    </tr> 
         
  <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������谡�Գ���</span></td>
	</tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
		<tr><td class=line2 style='height:1'></td></tr>           
    		    <tr>
        		    <td class='title' width=25%>���谡�Գ���</td>
        		    <td class='title' width=25%> �ְ��� �ݾ�</td>
        		     <td class='title' width=25%>��������</td>
        		     <td  class='title' > </td>
        		  </tr>
        		   <tr>
        		    <td  width=25% align=center><%=AddUtil.ChangeDate2(gins.getGi_start_dt())%>~<%=AddUtil.ChangeDate2(gins.getGi_end_dt())%></td>
        		    <td  width=25% align=right><%=AddUtil.parseDecimal(gins.getGi_amt())%></td>
        		     <td width=25% align=center ><%=gins.getGi_jijum()%></td>
        		     <td> </td>
        		   </tr>  
		    </table>
	    </td>
    </tr>

     <tr>
        <td class=h></td>
    </tr> 
    
     <tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>û������</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		       
	                 <tr>
	                   <td width="12%" class=title rowspan=2>û������</td>
	                    <td width="12%" class=title rowspan=2>û���ݾ�</td>	                   
	                     <td width="24%" class=title  colspan=2>���������</td>
	                      <td width="12%" class=title  rowspan=2>�����</td>
	                      <td width="40%" class=title rowspan=2>�Աݿ�û����</td>	                
	                </tr>
	                 <tr>
	                    <td width="12%" class=title>�����</td>
	                     <td width="12%" class=title>����ó</td>
	                </tr>
	       			<tr>
	       			   <td width="12%"  align=center>&nbsp;<input type='text' name='req_dt' value='<%=AddUtil.ChangeDate2(carGur.getReq_dt())%>' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '></td>
	                    <td width="12%"  align=center>&nbsp;<input type='text' name='req_amt' value='<%=AddUtil.parseDecimal(carGur.getReq_amt())%>' size='15' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); '></td>	                  
	                     <td width="12%"  align=center >&nbsp;<input type='text' name='guar_nm' value='<%=carGur.getGuar_nm()%>' size='20' class='text' ></td>
	                      <td width="12%"  align=center>&nbsp;<input type='text' name='guar_tel'  value='<%=carGur.getGuar_tel()%>' size='20' class='text' ></td>
	                       <td width="12%" align=center>&nbsp;
	                          <select name='damdang_id'>
	                           <option value="">����</option>
			                <%	if(user_size > 0){
									for(int i = 0 ; i < user_size ; i++){
										Hashtable user = (Hashtable)users.elementAt(i); %>
			                <option value='<%=user.get("USER_ID")%>' <%if(carGur.getDamdang_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
			                <%		}
								}%>
			              </select>
			              </td>
			               <td width="40%" align=center>&nbsp;
			        	    &nbsp;<input type="text" name="bank_nm" value="<%=carGur.getBank_nm()%>" size="20" class=text readonly >
				           &nbsp;<input type="text" name="bank_no" value="<%=carGur.getBank_no()%>" size="20" class=text readonly ></td>        	                                
	                </tr>
		       </table>
		      </td>        
         </tr>
                
       <tr>
        <td class=h></td>
      </tr> 
      <tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Աݰ���</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		       
	                 <tr>
	                  <td width="10%" class=title rowspan=2>�Ա�����</td>
	                    <td width="10%" class=title rowspan=2>�Աݱݾ�</td>	                    
	                     <td width="80%" class=title  colspan=2>û���ݾ״�� ����</td>
	                  <!--    <td width="10%" class=title  rowspan=2>�Ա���ä���ܾ�</td>	       -->                        
	                </tr>
	                  <tr>
	                    <td width="10%" class=title>�ݾ�</td>
	                     <td width="70%" class=title>����</td>
	                 </tr>
	          	 <tr>
	          			   <td width="10%"  align=center>&nbsp;<input type='text' name='ip_dt'  size='11' class='text'   	value="<%if(carGur.getIp_dt().equals("")) {%><%=AddUtil.getDate()%><%} else {%><%=AddUtil.ChangeDate2(carGur.getIp_dt())%><%}%>"  onBlur='javascript: this.value = ChangeDate(this.value); '></td>
	                      <td width="10%"  align=center>&nbsp;<input type='text' name='ip_amt'  size='15' class='num'  value=<%=AddUtil.parseDecimal(carGur.getIp_amt())%> onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>
	                      <td width="10%"  align=center>&nbsp<input type='text' name='req_i_amt' size='15' class='num' readonly  value=<%=AddUtil.parseDecimal(req_i_amt)%> ></td>	             
	                      <td width="45%" align=center>&nbsp;<input type='text' name='remark' value='<%=carGur.getRemark()%>' size='110' class='text' ></td>
	                 <!--      <td width="10%"><input type='text' name='gi_j_amt' value='' size='15' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td> -->
	                                
	                </tr>
		       </table>
		      </td>        
         </tr>   
                  
         <tr>
	    <td align="right">&nbsp;</td>
	</tr>	
	
	 <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("ä�ǰ�����",user_id)  || nm_db.getWorkAuthUser("�������",user_id) ) {%>
	 <tr>
	    <td align="center">&nbsp;
	    <%// if ( carGur.getIp_amt() < 1 ) {%> 
	   		 <a href="javascript:window.save();"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle></a>
	   		&nbsp;
			 <a href='javascript:doc_del()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_delete.gif" align="absmiddle" border="0"></a>
			
	
	    <% //} %>
	    </td>
	</tr>
	<% } %>		
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>				
	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;	
//-->
</script>
</body>
</html>