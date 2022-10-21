<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.credit.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
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
	
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
		//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
		
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();
	
			//����� ����Ʈ
	Vector users1 = c_db.getUserList("", "", "SACTION");
	int user_size1 = users1.size();
	
	
	
	
	
	
	//�����Ƿ�����
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String cls_st = cls.getCls_st();
	
	//�����Ƿڻ������
	ClsEtcSubBean clss = ac_db.getClsEtcSubCase(rent_mng_id, rent_l_cd, 1);

	//ä�ǰ�������
	CarCreditBean carCre = ac_db.getCarCredit(rent_mng_id, rent_l_cd);	
	
		//���뺸���� 
	Vector gurs = a_db.getContGurList(rent_mng_id,  rent_l_cd);
	int gur_size = gurs.size();
	
	Vector cms_bnk = c_db.getCmsBank();	//������� �����´�.
	int cms_bnk_size1 = cms_bnk.size();		
	
		//������Ÿ �߰� ����
	ClsEtcMoreBean clsm = ac_db.getClsEtcMore(rent_mng_id, rent_l_cd);

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
					
		if(!confirm("�����Ͻðڽ��ϱ�?"))	return;
		//fm.target = "i_no";
		fm.submit();
	}

//-->
</script>
</head>

<body>
<center>
<form name='form1' action='updateClsEtc_a.jsp' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
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
                <tr> 
                    <td class='title' width='20%'>������ȣ</td>
                    <td width='20%' align="center"><%=cr_bean.getCar_no()%></td>
    			    <td class='title' width='15%'>����</td>
                    <td width='45%'>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>  
    <tr> 
        <td align="right"></td>
    </tr>

	<tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
	
		<tr> 
	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������&nbsp;</span></td>
	    </tr> 	
		<tr>
	        <td class=line2></td>
	    </tr>
	    <tr> 
	      <td class='line'> 
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
	          <tr> 
	            <td width='13%' class='title'>��������</td>
	            <td width="13%">&nbsp; 
				  <select name="cls_st"  >
				    <option value="1" <%if(cls.getCls_st().equals("��ุ��"))%>selected<%%>>��ุ��</option>
				    <option value="7" <%if(cls.getCls_st().equals("���������(����)"))%>selected<%%>>���������(����)</option>
	                <option value="8" <%if(cls.getCls_st().equals("���Կɼ�"))%>selected<%%>>���Կɼ�</option>
	                <option value="2" <%if(cls.getCls_st().equals("�ߵ��ؾ�"))%>selected<%%>>�ߵ��ؾ�</option>
	                <option value="10" <%if(cls.getCls_st().equals("����������(�縮��)"))%>selected<%%>>����������(�縮��)</option>
	                <option value="14" <%if(cls.getCls_st().equals("����Ʈ����"))%>selected<%%>>����Ʈ����</option>
			      </select> </td>
	                      					  
	            <td width='13%' class='title'>�Ƿ���</td>
	            <td width="12%">&nbsp;
	              <select name='reg_id'  >
	                <option value="">����</option>
	                <%	if(user_size > 0){
							for(int i = 0 ; i < user_size ; i++){
								Hashtable user = (Hashtable)users.elementAt(i); %>
	                <option value='<%=user.get("USER_ID")%>' <%if(cls.getReg_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
	                <%		}
						}%>
	              </select></td>	
	                      
	            <td width='13%' class='title'>��������</td>
	            <td width="12%">&nbsp;
				  <input type='text' name='cls_dt' value='<%=AddUtil.ChangeDate2(cls.getCls_dt())%>'  size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '></td> 
			    <td width='13%' class='title'>�̿�Ⱓ</td>
			    <td >&nbsp;
			       <input type='text' name='r_mon' class='text' size='2' value='<%=cls.getR_mon()%>'  >����&nbsp;<input type='text' name='r_day' size='2' class='text' value='<%=cls.getR_day()%>'  >��&nbsp;</td>
	          </tr>
	          
	          <tr> 
	            <td class='title'>���� </td>
	            <td colspan="5">&nbsp;
	              <textarea name="cls_cau" cols="100" class="text" style="IME-MODE: active" rows="3"><%=cls.getCls_cau()%></textarea>				
	            </td>
	             <td width="12%" class=title >�����Ī<br>��������</td>
                      <td>&nbsp; 
		       <select name="match" >
		           <option value="" <% if(cls.getMatch().equals("")){%>selected<%}%>>--����--</option>
                              <option value="Y" <% if(cls.getMatch().equals("Y")){%>selected<%}%>>�����Ī</option>           
                          </select>
                      </td>
	          </tr>
	          <tr>                                                      
	            <td class=title >�ܿ�������<br>������ҿ���</td>
	     	    <td>&nbsp; 
				  <select name="cancel_yn" onChange='javascript:cancel_display()' disabled >
	                <option value="N" <% if(cls.getCancel_yn().equals("N")){%>selected<%}%>>��������</option>
	                <option value="Y" <% if(cls.getCancel_yn().equals("Y")){%>selected<%}%>>�������</option>
	              </select>
			    </td>
	            <td  colspan="6" align=left>&nbsp;�� ����� ��꼭�� ���� �Ǵ� ��ҿ��� �� Ȯ���� �ʿ�, ������ҽ� ���̳ʽ� ���ݰ�꼭 ���� </td>
	          </tr>
	                
	        </table>
	      </td>
	    </tr>
	    
	    <tr></tr><tr></tr><tr></tr>
	    <tr> 
	         <td class="line">
	                <table width="100%" border="0" cellspacing="1" cellpadding="0">
	                    <tr> 
	                        <td class="title" width=12% >����Ÿ�</td>
	                        <td width=13% >&nbsp; <input type='text' name='tot_dist' size='10' value='<%=AddUtil.parseDecimal(cls.getTot_dist())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;km </td>
	                        <td  colspan="4" align=left>&nbsp;�� �ߵ����� �� ����� ��������Ÿ� </td>
	                    </tr>                 
	                                  
	                </table>
	          </td>
	   </tr> 
		          
	   <tr></tr><tr></tr><tr></tr>
	   <tr>
	        <td class=line>
	            <table width=100% border=0 cellspacing=1 cellpadding=0>
	       		  <tr>
	                    <td class=title width=10%>��ü�ᰨ��<br>������</td>
	                    <td width=12%>&nbsp;
							   <select name='dly_saction_id'>
				                <option value="">--����--</option>
				                 <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
				                 <option value='<%=user1.get("USER_ID")%>' <%if(cls.getDly_saction_id().equals((String)user1.get("USER_ID"))){%>selected<%}%>><%= user1.get("USER_NM")%></option>				                 <%		}
								 	}%>		              
				              </select>
				        </td>
	                    <td class=title width=12%>��ü�� ���׻���</td>
	                    <td colspan=3>&nbsp;<textarea name="dly_reason" cols="105" class="text" style="IME-MODE: active" rows="2"><%=cls.getDly_reason()%></textarea></td> 
					 
	                </tr>
	                <tr>
	                	<td class=title width=10%>�ߵ����������<br>���� ������</td>
	                    <td width=12%>&nbsp;
							   <select name='dft_saction_id'>
				                <option value="">--����--</option>
				                 <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
				                 <option value='<%=user1.get("USER_ID")%>' <%if(cls.getDft_saction_id().equals((String)user1.get("USER_ID"))){%>selected<%}%>><%= user1.get("USER_NM")%></option>
				                 <%		}
								 	}%>		              
				              </select>
				        </td>
	                    <td class=title width=12%>�ߵ����������<br>���׻���</td>
					    <td colspan=3>&nbsp;<textarea name="dft_reason" cols="105" class="text" style="IME-MODE: active" rows="2"><%=cls.getDft_reason()%></textarea></td> 
					    
	                </tr>
	                <tr> 
	                  	<td class=title width=10%>Ȯ���ݾװ�����</td>
	                    <td width=12%>&nbsp;
							   <select name='d_saction_id'>
				                <option value="">--����--</option>
				                 <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
				                 <option value='<%=user1.get("USER_ID")%>' <%if(cls.getD_saction_id().equals((String)user1.get("USER_ID"))){%>selected<%}%>><%= user1.get("USER_NM")%></option>
				                 <%		}
								 	}%>		              
				              </select>
				        </td>
	                    <td class=title width=12%>Ȯ���ݾ� ����</td>
	                    <td colspan=3>&nbsp;<textarea name="d_reason" cols="105" class="text" style="IME-MODE: active" rows="2"><%=cls.getD_reason()%></textarea></td> 					   
	                </tr>
					    <tr> 
	                  	<td class=title width=10%>�������ĺ�ó��������</td>
	                    <td width=12%>&nbsp;
							   <select name='ext_saction_id'>
				                <option value="">--����--</option>
				                 <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
				                 <option value='<%=user1.get("USER_ID")%>' <%if(cls.getExt_saction_id().equals((String)user1.get("USER_ID"))){%>selected<%}%>><%= user1.get("USER_NM")%></option>
				                 <%		}
								 	}%>		              
				              </select>
				        </td>
	                    <td class=title width=12%>Ȯ���ݾ� ����</td>
	                    <td colspan=3>&nbsp;<textarea name="ext_reason" cols="105" class="text" style="IME-MODE: active" rows="2"><%=cls.getExt_reason()%></textarea></td> 
					   
	                </tr>
	                </table>
	         </td>       
   		 </tr>       
	     <tr></tr><tr></tr><tr></tr>
		 <tr>
				<td>
					<table width=100%  border=0 cellspacing=1 cellpadding=0>
		                <tr>
					        <td class=line colspan=8>
					            <table width=100%  border=0 cellspacing=1 cellpadding=0>
					                <tr>              
					                    <td class=title style='height:44' width=13%>ó���ǰ�/���û���/����</td>
					                    <td colspan=7>&nbsp;
					                    <textarea name="remark" cols="140" class="text" style="IME-MODE: active" rows="3"><%=cls.getRemark()%></textarea> 
					                    </td>
					                </tr>
		                
		           				</table>
		           			</td>
		           		</tr>
		           	</table>			
		        </td>
		    </tr>
	    
    	</table>
      </td>	 
    </tr>	
    
      <tr></tr><tr></tr><tr></tr>
	<tr> 
	       <td class="line">
	               <table width="100%" border="0" cellspacing="1" cellpadding="0">
	                    <tr> 
	                        <td class="title" width=12% >����ȿ�������</td>
	                        <td width="13%">&nbsp; 
							  <select name="dft_cost_id"  >
							       <option value="">--����--</option>
				                 <%	if(user_size > 0){
									for(int i = 0 ; i < user_size ; i++){
										Hashtable user = (Hashtable)users.elementAt(i); %>
				                 <option value='<%=user.get("USER_ID")%>' <%if(cls.getDft_cost_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
				                 <%		}
								 	}%>		              
				              </select>				              
				
			                </td>	                      
	                        <td  colspan="4" align=left>&nbsp;�� ����ȿ������ڸ� �߸� �Է½� �����ϼ���.  </td>
	                    </tr>                 
	                                  
	                </table>
	       </td>
	</tr> 
	
    
    <tr></tr><tr></tr><tr></tr>
	<tr> 
	       <td class="line">
	               <table width="100%" border="0" cellspacing="1" cellpadding="0">
	                    <tr> 
	                        <td class="title" width=12% >CMS�����Ƿ�</td>
	                        <td width="13%">&nbsp; 
							  <select name="cms_chk"  >
							    <option value="" <%if(cls.getCms_chk().equals(""))%>selected<%%>>����</option>
				                <option value="Y" <%if(cls.getCms_chk().equals("Y"))%>selected<%%>>CMS�Ƿ�</option>
				                <option value="N" <%if(cls.getCms_chk().equals("N"))%>selected<%%>>CMS���Ƿ�</option>				           
						      </select>
			                </td>	                      
	                      <td  colspan="3" align=left>&nbsp;�� �ߵ������������ CMS�� �����ϰ����� ���� CMS�����Ƿڿ� check �ϼ���. </td>
	                      <td><input type='checkbox' name='cms_after' value='Y' <%if(clsm.getCms_after().equals("Y")){%>checked<%}%> ><font color="red">CMS Ȯ���� ����ó��</font></td>
	                    </tr>                 
	                                  
	                </table>
	       </td>
	</tr> 
		   
    <tr></tr><tr></tr><tr></tr>
    <tr id=tr_refund style="display:<%if( cls.getFdft_amt2() < 0 && !cls.getCls_st().equals("���Կɼ�") ){%>''<%}else{%>none<%}%>"> 
            <td class="line">
                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                    <tr> 
                        <td class="title" width=13% >�����ָ�</td>
                        <td >&nbsp; <input type="text" name="re_acc_nm" value='<%=cls.getRe_acc_nm()%>' size="30" class=text></td>
                        <td width=13% class="title">�����</td>
                        <td >&nbsp; <select name="re_bank" style="width:135">
                            <option value="">==����==</option>                         
			     	 <% if(cms_bnk_size1 > 0){
						for(int i = 0 ; i < cms_bnk_size1 ; i++){
							Hashtable h_c_bnk = (Hashtable)cms_bnk.elementAt(i); %>  
					    	<option value='<%=h_c_bnk.get("BCODE")%>'  <%if(cls.getRe_bank().equals((String)h_c_bnk.get("BCODE"))){%>selected<%}%>><%= h_c_bnk.get("BNAME")%></option> > 	
                     
				              <%		}
							}%>
				              </select></td>
                        <td width=13% class="title">���¹�ȣ</td>
                        <td >&nbsp; <input type="text" name="re_acc_no" value='<%=cls.getRe_acc_no()%>' size="30" class=text></td>
                    </tr>                 
                                  
                </table>
            </td>
    </tr>               	 	
         
    <tr> 
        <td align="right">
        
            <%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
            <a href='javascript:save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
            <%}%>
            <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
	
</table>

</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
