<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.fee.*,acar.client.*"%>
<%@ page import="acar.cont.*, acar.ext.*, acar.car_register.*"%>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();

	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String auth_rw 		= request.getParameter("auth_rw")  ==null?acar_br   :request.getParameter("auth_rw");
			
	String s_kd 		= request.getParameter("s_kd")	==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")	==null?"" :request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")	==null?"":request.getParameter("andor");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	
	String now_stat	 	= request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	String san_st	 	= request.getParameter("san_st")==null?"":request.getParameter("san_st");
	
	String mode	 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	if(mode.equals("pay_view")){
		//���°� Ȥ�� ���������϶� �°��� ��������
		Hashtable cng_cont = af_db.getScdFeeCngContA(rent_mng_id, rent_l_cd);
		rent_l_cd = cng_cont.get("RENT_L_CD")+"";
	}	
		
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
		
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--    
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body>
<form action='' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 			value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 			value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 			value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 			value='<%=end_dt%>'>    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="idx" 			value="">
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <%if(mode.equals("pay_view")){ 
    
    	//���°� Ȥ�� ���������϶� ����� ��������
    	Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
    	
    	//������
    	ClientBean client = al_db.getNewClient(base.getClient_id());
    %>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ �����</span></td>
    </tr>
    <tr>
      <td class=line2></td>
    </tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding='0' width=100%>		
                <tr> 
                    <td class=title width=13%>���汸��</td>
                    <td width=20%>&nbsp;<%=begin.get("CLS_ST")%> <%=begin.get("RENT_L_CD")%></td>
                    <td class=title width=10%>��������</td>
                    <td width=20%>&nbsp;<%=begin.get("CLS_DT")%></td>
                    <%if(String.valueOf(begin.get("CLS_ST")).equals("���°�")){%>
                    <td class=title width=10%>��</td>
                    <td>&nbsp;<%=begin.get("FIRM_NM")%>&nbsp;<%=begin.get("CLIENT_NM")%></td>
                    <%}else if(String.valueOf(begin.get("CLS_ST")).equals("��������")){%>
                    <td class=title width=10%>�ڵ���</td>
                    <td>&nbsp;<%=begin.get("CAR_NO")%>&nbsp;<%=begin.get("CAR_NM")%></td>
                    <%}%>
                </tr>
                <tr>
                  <td class=title>��������</td>
                  <td colspan="5">&nbsp;<%=begin.get("CLS_CAU")%></td>
                </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>    
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��</span>(<%=client.getClient_id()%>)</td>
    </tr>
    <tr>
      <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>��ȣ/����</td>
                    <td <%if(client.getClient_st().equals("2")){%>colspan='3'<%}%>>&nbsp;<%=client.getFirm_nm()%>
                    	(
                    	<%if(client.getClient_st().equals("2")){%>
                    	  <%=client.getSsn1()%>-<%=client.getSsn2().substring(0,1)%>
                    	<%}else{%>
                    	  <%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%>
                    	<%}%>
                    	)                     
                    </td>
                    <%if(!client.getClient_st().equals("2")){%>
                    <td width='10%' class='title'>��ǥ��</td>
                    <td align='left'>&nbsp;<%=client.getClient_nm()%></td>
                    <%}%>
                </tr>
                <tr>
                    <td class='title'>����ó</td>
                    <td colspan='3'>&nbsp;
                    	<%if(!client.getClient_st().equals("2")){%>
                    	ȸ����ȭ : <%=AddUtil.phoneFormat(client.getO_tel())%>, ��ǥ���ڵ��� : <%=AddUtil.phoneFormat(client.getM_tel())%><%if(!client.getClient_st().equals("1")){%>, ������ȭ : <%=AddUtil.phoneFormat(client.getH_tel())%><%}%>
                    	<%}else{%>
                    	���޴��� : <%=AddUtil.phoneFormat(client.getM_tel())%>, ������ȭ : <%=AddUtil.phoneFormat(client.getH_tel())%>, ������ȭ : <%=AddUtil.phoneFormat(client.getO_tel())%>
                    	<%}%>
                    </td>
                </tr>                
            </table>
        </td>
    </tr>    
    <%} %>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle>&nbsp;���°�</td>
    </tr>      
    <%	
    	
	ExtScdBean suc2 = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, "1", "5", "1");//���� ��� ���� ��ȸ
	
	//���Ծ��� �°������ �δ�
	if(cont_etc.getRent_suc_commi_pay_st().equals("1") && cont_etc.getRent_suc_commi() != (suc2.getExt_s_amt()+suc2.getExt_v_amt()) ){
		suc2 = ae_db.getAGrtScd(rent_mng_id, cont_etc.getRent_suc_l_cd(), "1", "5", "1");//���� ��� ���� ��ȸ
	}
    %>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=13%>���°�����</td>
                    <td>&nbsp;
    			    <input type="text" name="rent_suc_dt" value="<%=AddUtil.ChangeDate2(cont_etc.getRent_suc_dt())%>" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                    <td class=title>�°��������Ÿ�</td>
                    <td>&nbsp;
    			    <input type="text" name="rent_suc_dist" value="<%=AddUtil.parseDecimal(cont_etc.getRent_suc_dist())%>" size="11" maxlength='10' class=num onBlur='javascript:this.value=parseDecimal(this.value)'>km
    	            </td>		        			    
    		</tr>	  
				<tr>
                    <td class=title width=13%>���-�°��Ʈ</td>
                    <td colspan='3'>&nbsp;
    			    	<textarea name="rent_suc_route" cols="100" class="text" style="IME-MODE: active" rows="3"><%=cont_etc.getRent_suc_route()%></textarea> 						
					</td>					
				</tr>    		  
		<tr>			
					</td>	
                    <td class=title width=13%>���°������</td>
                    <td colspan='3'>&nbsp;
        			  <input type='text' size='11' name='rent_suc_commi' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getRent_suc_commi())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��
					  &nbsp;&nbsp;&nbsp;
					  <% 	if(suc2 == null || suc2.getRent_l_cd().equals("")){%> 
					  ���ް� : <input type='text' size='8' name='suc_commi_s_amt' maxlength='10' class='num' value='0' onBlur='javascript:this.value=parseDecimal(this.value);'>��
					  �ΰ��� : <input type='text' size='8' name='suc_commi_v_amt' maxlength='10' class='num' value='0' onBlur='javascript:this.value=parseDecimal(this.value);'>��					  
					  &nbsp;&nbsp;&nbsp;					  
					  <% 		if(AddUtil.parseInt(cont_etc.getRent_suc_dt()) >= 20100520){%> 	
					  <br>&nbsp;
						(������ ���� -> 
					    <!--<input type="checkbox" name="suc_tax_req" value="Y"> ��꼭 ����, -->
						�Աݿ����� : <input type='text' name='suc_commi_est_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'>
						<a href="javascript:make_suc_schedule();"><img src=/acar/images/center/button_sch_cre.gif  align=absmiddle border="0"></a> )
					  <%		}%>
					  <%	}else{%>
					  ���ް� : <input type='text' size='8' name='suc_commi_s_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(suc2.getExt_s_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��
					  �ΰ��� : <input type='text' size='8' name='suc_commi_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(suc2.getExt_v_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��					  
					  &nbsp;&nbsp;&nbsp;
					  <%	}%>				   				   
				   &nbsp;&nbsp;&nbsp;
				   
           <% int car_amt = car.getCar_cs_amt()+car.getOpt_cs_amt()+car.getClr_cs_amt()+car.getCar_cv_amt()+car.getOpt_cv_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt();%>
				   
           <%if(AddUtil.parseInt(base.getReg_dt()) < 20170220){//20170220 ���� 0.7*1.1%>
               * ����°������ : <%=AddUtil.parseDecimal(car_amt*0.7/100*1.1)%>��	
               (�����Һ��ڰ� <%=AddUtil.parseDecimal(car_amt)%>��*0.7%*1.1, �ΰ�������)                        
           <%}else{%>   
               * ����°������ : <%=AddUtil.parseDecimal(car_amt*0.8/100)%>��	                     
               (�����Һ��ڰ� <%=AddUtil.parseDecimal(car_amt)%>���� 0.8%, �ΰ�������)
           <%}%> 
					  
					  </td>
                    
                </tr>
                
				<tr>
                    <td class=title width=13%>�°�����ᰨ�����</td>
                    <td colspan='3'>&nbsp;
    			    	<select name='rent_suc_exem_cau'>
                                      <option value="">����</option>
                                      <option value="1" <%if(cont_etc.getRent_suc_exem_cau().equals("1")){%>selected<%}%>>���� ��ȯ (���װ���)</option>
                                      <option value="2" <%if(cont_etc.getRent_suc_exem_cau().equals("2")){%>selected<%}%>>�̿��� ���� (50%����)</option>
                                      <option value="3" <%if(cont_etc.getRent_suc_exem_cau().equals("3")){%>selected<%}%>>�������� Ư������</option>
                                      <%if(cont_etc.getRent_suc_exem_cau().equals("5")){%>
                                      <option value="5" <%if(cont_etc.getRent_suc_exem_cau().equals("5")){%>selected<%}%>>������Ʈ �°����� ���</option>
                                      <%}%>
                                      <option value="4" <%if(!cont_etc.getRent_suc_exem_cau().equals("") && !cont_etc.getRent_suc_exem_cau().equals("1") && !cont_etc.getRent_suc_exem_cau().equals("2") && !cont_etc.getRent_suc_exem_cau().equals("3") && !cont_etc.getRent_suc_exem_cau().equals("5")){%>selected<%}%>>��Ÿ (���� ���� �Է�)</option>
                      </select>       
                      <%if(cont_etc.getRent_suc_exem_cau().equals("") || (cont_etc.getRent_suc_exem_cau().equals("1") && !cont_etc.getRent_suc_exem_cau().equals("2") && !cont_etc.getRent_suc_exem_cau().equals("3") && !cont_etc.getRent_suc_exem_cau().equals("5"))){%>                      
                      <input type='text' name='rent_suc_exem_cau_sub' size='30' class='text' value="<%=cont_etc.getRent_suc_exem_cau()%>">    					
                      <%}else{%>
                      <input type='hidden' name="rent_suc_exem_cau_sub"		value="<%=cont_etc.getRent_suc_exem_cau()%>">
                      <%}%>
                      <%if(cont_etc.getRent_suc_exem_cau().equals("5")){%>
                      <br>&nbsp;
                       �� ������Ʈ �°����� ��� : ����°������ 11����(VAT����) ���ϴ� �°������ ���׸���, ����°������ 11����(VAT����) �̻��� �°������ 11����(VAT����)�� ���׵˴ϴ�.
                      <%}%>
					</td>					
                </tr>
                
				<tr>					
					<td class=title width=13%>�����ᰨ�� ������</td>
					<td colspan='3'>&nbsp;
					        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(cont_etc.getRent_suc_exem_id(), "USER")%>" size="12"> 
			                        <input type="hidden" name="rent_suc_exem_id" value="<%=cont_etc.getRent_suc_exem_id()%>">			                        
					</td>					
				</tr>	
		
				<tr>
                    <td class=title width=13%>���δ���</td>
                    <td colspan='3'>&nbsp;
    			    	<select name='rent_suc_commi_pay_st'>
                           <option value="">����</option>
                           <option value="1" <%if(cont_etc.getRent_suc_commi_pay_st().equals("1")){%>selected<%}%>>�������</option>
                           <option value="2" <%if(cont_etc.getRent_suc_commi_pay_st().equals("2")){%>selected<%}%>>���°���</option>
                        </select>
						
					</td>					
				</tr>
				<tr>
                    <td class=title width=13%>�������̰�ȸ��</td>
                    <td width=50%>&nbsp;
    			    	<input type='text' size='2' name='rent_suc_fee_tm' maxlength='12' class='text' value='<%=cont_etc.getRent_suc_fee_tm()%>' >ȸ��						
					</td>					
					<td class=title width=10%>���ڰ�������</td>
					<td>&nbsp;
						<input type="text" name="rent_suc_fee_tm_b_dt" value="<%=AddUtil.ChangeDate2(cont_etc.getRent_suc_fee_tm_b_dt())%>" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value)'> 
						
					</td>					
				</tr>						
				<tr>
                    <td class=title width=13%>������</td>
                    <td width=50%>&nbsp;
    			    	�����
						<input type='text' size='11' name='suc_grt_suc_o_amt' maxlength='12' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��						
						, �°���
						<input type='text' size='11' name='suc_grt_suc_r_amt' maxlength='12' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��						
						
					</td>					
					<td class=title width=13%>�����ݽ°迩��</td>
					<td>&nbsp;
						<select name='rent_suc_grt_yn'>  
                           <option value="">����</option>
                           <option value="0" <%if(cont_etc.getRent_suc_grt_yn().equals("0")){%>selected<%}%>>�°�</option>
                           <option value="1" <%if(cont_etc.getRent_suc_grt_yn().equals("1")){%>selected<%}%>>����</option>
                        </select>
					</td>					
				</tr>					
				<tr>
                    <td class=title width=13%>������</td>
                    <td width=50%>&nbsp;
    			    	�����
						<input type='text' size='11' name='suc_pp_suc_o_amt' maxlength='12' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getPp_suc_o_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��						
						, �°���
						<input type='text' size='11' name='suc_pp_suc_r_amt' maxlength='12' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getPp_suc_r_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��						
						
					</td>					
					<td class=title width=13%>�����ݽ°迩��</td>
					<td>&nbsp;
						<select name='rent_suc_pp_yn'>  
                           <option value="">����</option>
                           <option value="0" <%if(cont_etc.getRent_suc_pp_yn().equals("0")){%>selected<%}%>>�°�</option>
                           <option value="1" <%if(cont_etc.getRent_suc_pp_yn().equals("1")){%>selected<%}%>>����</option>
                        </select>
					</td>					
				</tr>	
				<tr>
                    <td class=title width=13%>���ô뿩��</td>
                    <td width=50%>&nbsp;
    			    	�����
						<input type='text' size='11' name='suc_ifee_suc_o_amt' maxlength='12' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getIfee_suc_o_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��						
						, �°���
						<input type='text' size='11' name='suc_ifee_suc_r_amt' maxlength='12' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getIfee_suc_r_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��						
						
					</td>					
					<td class=title width=13%>���ô뿩��°迩��</td>
					<td>&nbsp;
						<select name='rent_suc_ifee_yn'>  
                           <option value="">����</option>
                           <option value="0" <%if(cont_etc.getRent_suc_ifee_yn().equals("0")){%>selected<%}%>>�°�</option>
                           <option value="1" <%if(cont_etc.getRent_suc_ifee_yn().equals("1")){%>selected<%}%>>����</option>
                        </select>
					</td>					
				</tr>	
				<tr>
                    <td class=title width=13%>�̻��Ⱓ</td>
                    <td colspan='3'>&nbsp;
    			    	<input type='text' size='3' name='n_mon' maxlength='3' class='num' value='<%=cont_etc.getN_mon()%>'>����						
						<input type='text' size='3' name='n_day' maxlength='3' class='num' value='<%=cont_etc.getN_day()%>'>��						
					</td>					
				</tr>					
						
            </table>
	    </td>
    </tr>
</table>
  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>