<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.cont.*, acar.secondhand.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="shDb" scope="page" class="acar.secondhand.SecondhandDatabase"/>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String f_page = request.getParameter("f_page")==null?"":request.getParameter("f_page");
	
	//�α���ID&������ID&����
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "05", "01");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "EMP"); //����� ����Ʈ
	int user_size = users.size();	
	
	//��������
	Hashtable reserv = rs_db.getCarInfo(c_id);
	//�ܱ�������
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);	
	//������
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());	
	String rent_st = rc_bean.getRent_st();
	//����������
	ScdRentBean sr_bean1 = rs_db.getScdRentCase(s_cd, "1");
	ScdRentBean sr_bean2 = rs_db.getScdRentCase(s_cd, "2");	
	//�ܱ�뿩����
	RentFeeBean rf_bean = rs_db.getRentFeeCase(s_cd);
	
	//������������
	Hashtable reserv2 = rs_db.getCarInfo(rc_bean.getSub_c_id());
	
	//���ݽ�����
	Vector conts = rs_db.getScdRentList(s_cd, "");
	int cont_size = conts.size();
	
	
	//����Ʈ2ȸ���뿩�� ������ �ڵ���ü����Ȯ���Ͽ� ����ϵ���
	
	//�ڵ���ü�� ���� cont ���� �����
	String rm_rent_mng_id = c_id;
	String rm_rent_l_cd   = "RM00000"+s_cd;
	String cms_est_dt = "";
	
	//cms_mng
	ContCmsBean cms = a_db.getCmsMng(rm_rent_mng_id, rm_rent_l_cd);	
	
	int cms_scd_cnt = 0;
	
	
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAll("0003"); 
	int bank_size = banks.length;	
				
	//������ ���� 
  CodeBean[] goods = c_db.getCodeAll3("0027");
  int good_size = goods.length;
  
	//�縮���������� �������
	Vector sr = shDb.getShResList(c_id);
	int sr_size = sr.size();
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
	//�����ϱ�
	function save(){
		var fm = document.form1;
		if(fm.deli_dt.value == ''){ 		alert('�����Ͻø� �Է��Ͻʽÿ�'); 			fm.deli_dt.focus(); 		return; }
		if(fm.deli_loc.value == ''){ 		alert('������ġ�� �Է��Ͻʽÿ�'); 			fm.deli_loc.focus(); 		return; }		
		if(fm.deli_mng_id.value == ''){ 	alert('��������ڸ� �����Ͻʽÿ�'); 		fm.deli_mng_id.focus(); 	return; }						
		if(fm.deli_dt.value != '')
			fm.h_deli_dt.value = fm.deli_dt.value+fm.deli_dt_h.value+fm.deli_dt_s.value;		
				
		if(fm.ret_plan_dt.value != '')
			fm.h_ret_plan_dt.value = fm.ret_plan_dt.value+fm.ret_plan_dt_h.value+fm.ret_plan_dt_s.value;
		
		
		
		if(<%=sr_size%> > 0 && !confirm('�ش� ������ �縮�� �� <%=sr_size%>���� ���� ������Դϴ�. �������ڵ鿡�� Ȯ�� �� ���� ��������')){	return;	}
			
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		fm.action = 'res_action_a.jsp';
		fm.target = 'i_no';
		fm.submit();			
	}
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.deli_dt.focus();">

<form action="" name="form1" method="post" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_cd' value='<%=s_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='f_page' value='<%=f_page%>'>
<input type='hidden' name='h_deli_dt' value=''>
<input type='hidden' name='h_ret_plan_dt' value=''>
<input type='hidden' name='car_no' value='<%=reserv.get("CAR_NO")%>'>        
<input type='hidden' name='c_firm_nm' value='<%=rc_bean2.getFirm_nm()%>'>         
<input type='hidden' name='c_client_nm' value='<%=rc_bean2.getCust_nm()%>'>      
<input type='hidden' name='cms_est_dt' value='<%=cms_est_dt%>'>      
    

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>��������>�������� <span class=style5>�������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr>                     
                    <td class=title>������ȣ</td>
                    <td >&nbsp;<%=reserv.get("CAR_NO")%></td>
                    <td class=title  width=10%>����</td>
                    <td>&nbsp;<%=rc_bean2.getCust_nm()%></td>
                    <td class=title>��ȣ</td>
                    <td>&nbsp;<%=rc_bean2.getFirm_nm()%>
                    	<%if(rc_bean.getCust_id().equals("") && rc_bean.getRent_st().equals("6") && rc_bean.getEtc().equals("�ڻ����� �������� ��� �� �縮�� ������")){%>
                    		�ڻ�������
                    	<%}%>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=12%>����</td>
                    <td colspan="5">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%> (<%=reserv.get("SECTION")%>)</td>
                </tr>  
    			  <tr> 
                    <td class=title width=12%>�˻���ȿ�Ⱓ</td>
                    <td width=25%>&nbsp; 
                      <input type="text" name="maint_st_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_ST_DT")))%>" size="9" class=whitetext>
                      ~ 
                      <input type="text" name="maint_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_END_DT")))%>" size="9" class=whitetext>
                       </td>
                    <td class=title>���ɸ�����</td>
                    <td width=15% >&nbsp; 
                      <input type="text" name="car_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("CAR_END_DT")))%>" size="9" class=whitetext>
                    </td>
                    <td class=title>������ȿ�Ⱓ</td>
                    <td>&nbsp; 
                      <input type="text" name="test_st_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("TEST_ST_DT")))%>" size="9" class=whitetext>
                      ~&nbsp; 
                      <input type="text" name="test_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("TEST_END_DT")))%>" size="9" class=whitetext>
                    </td>
                </tr>
    		</table> 
      	</td>
    </tr>
    <%if(!rc_bean.getSub_c_id().equals("")){     	
    %>     	
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>                
                    <td class=title width=12%>������ȣ</td>
                    <td width=25%>&nbsp;<%=reserv2.get("CAR_NO")%></td>
                    <td class=title width=10%>����</td>
                    <td>&nbsp;<%=reserv2.get("CAR_NM")%>&nbsp;<%=reserv2.get("CAR_NAME")%></td>
                </tr>                
            </table>
        </td>
    </tr>    
    <%} %>  
    <%if(rc_bean.getSub_c_id().equals("") && !rc_bean.getSub_l_cd().equals("")){ 
    	//��������
    	reserv2 = a_db.getRentBoardSubCase(rc_bean.getSub_l_cd());
    %>     	
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>                
                    <td class=title width=12%>������ȣ</td>
                    <td width=25%>&nbsp;<%=reserv2.get("CAR_NO")%></td>
                    <td class=title width=10%>����</td>
                    <td>&nbsp;<%=reserv2.get("CAR_NM")%>&nbsp;<%=reserv2.get("CAR_NAME")%></td>
                </tr>                
            </table>
        </td>
    </tr>    
    <%} %>  
	<%if(sr_size>0){%>
    <tr> 
        <td class=h></td>
    </tr>    	
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�縮�� ��������</span></td>
    <tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
				<%	for(int i = 0 ; i < sr_size ; i++){
						Hashtable sr_ht = (Hashtable)sr.elementAt(i);
						%>
                <tr> 
                    <td class="title" width="12%">����</td>					
                    <td align="center" width="15%"><%	if(String.valueOf(sr_ht.get("SITUATION")).equals("0"))			out.print("�����");
        												else if(String.valueOf(sr_ht.get("SITUATION")).equals("2"))		out.print("���Ȯ��");  %>
        													
        											<%if(!String.valueOf(sr_ht.get("REG_CODE")).equals("")){
        														
        											%>
        											<br>
        											<font color='red'><b>�� ����Ʈ����</b></font>
        											<%}%>
        						
        						</td>										
                    <td class="title" width="10%">����Ⱓ</td>					
                    <td align="center"><%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_ST_DT"))) %>~<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_END_DT"))) %></td>															
                    <td class="title" width="10%">�����</td>					
                    <td align="center" width="10%"><%=c_db.getNameById(String.valueOf(sr_ht.get("DAMDANG_ID")),"USER")%></td>															                    
                    <td class="title" width="10%">����Ͻ�</td>					
                    <td align="center" width="15%"><%= AddUtil.ChangeDate3(String.valueOf(sr_ht.get("REG_DATE"))) %></td>
                </tr>	
                <tr>
                    <td class="title">�޸�</td>
                    <td colspan='7'>&nbsp;<%=sr_ht.get("CUST_NM")%>&nbsp;<%=sr_ht.get("CUST_TEL")%>&nbsp;<%=sr_ht.get("MEMO")%></td>
                </tr>					
				<%}%>
            </table>
	    </td>
    </tr>	

	<%}%>       
    <tr> 
        <td>&nbsp;</td>
    </tr> 
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����</span></td>
    <tr>	    
    <tr><td class=line2></td></tr>       
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr> 
                	<td class=title rowspan="7" width=5%>��<br>��</td>
                <tr> 
                    <td class=title >��౸��</td>
                    <td>&nbsp;
                <%if(rent_st.equals("1")){%>
                �ܱ�뿩 
                <%}else if(rent_st.equals("2")){%>
                ������� 
                <%}else if(rent_st.equals("3")){%>
                ������ 
                <%}else if(rent_st.equals("9")){%>
                ������� 
                <%}else if(rent_st.equals("10")){%>
                �������� 
                <%}else if(rent_st.equals("4")){%>
                �����뿩 
                <%}else if(rent_st.equals("5")){%>
                �������� 
                <%}else if(rent_st.equals("6")){%>
                �������� 
                <%}else if(rent_st.equals("7")){%>
                �������� 
                <%}else if(rent_st.equals("8")){%>
                ������ 
                <%}else if(rent_st.equals("11")){%>
                �����
                
                <%}%>	
                 &nbsp; (����Ͻ�:<%=AddUtil.ChangeDate3(rc_bean.getReg_dt())%>)
        			</td>
                </tr>
                <tr>         			                	
                    <td class=title width=15%>���������Ͻ�</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_plan_dt())%></td>
                </tr>
                <tr> 
                    <td class=title>�����Ͻ�</td>
                    <td> 
                        &nbsp;<input type="text" name="deli_dt" value="<%=AddUtil.ChangeDate2(rc_bean.getDeli_plan_dt_d())%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                        <select name="deli_dt_h">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getDeli_plan_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                        </select>
                        <select name="deli_dt_s" >
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getDeli_plan_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                        </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>������ġ</td>
                    <td>
                        &nbsp;<input type="text" name="deli_loc" value="<%=rc_bean.getDeli_loc()%>" size="60" class=text style='IME-MODE: active'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>���������</td>
                    <td>
                    &nbsp;<select name='deli_mng_id'>
                        <option value="">������</option>
                        <%if(user_size > 0){
        					for (int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(rc_bean.getBus_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}%>
                    </select>
    			    </td>
                </tr>
                <tr>
                	<td class=title>���������Ͻ�</td>
                    <td> 
                      &nbsp;<input type="text" name="ret_plan_dt" value="<%=AddUtil.ChangeDate2(rc_bean.getRet_plan_dt_d())%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <select name="ret_plan_dt_h">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_plan_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                        </select>
                        <select name="ret_plan_dt_s" >
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_plan_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                        </select>
                    </td>
            	</tr>
            </table>
        </td>
    </tr>
    
    
	<%if(rc_bean.getRent_st().equals("6") && rc_bean.getEtc().equals("�ڻ����� �������� ��� �� �縮�� ������")){%>
    <tr>
        <td class=h></td>
    </tr>	
	<tr><td class=line2></td></tr> 
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=17%>��������ġ</td>
                    <td> 
                      &nbsp;<SELECT NAME="park" >
						<%for(int i = 0 ; i < good_size ; i++){
                  				CodeBean good = goods[i];%>
                        <option value='<%= good.getNm_cd()%>' 
                        	<%if(String.valueOf(reserv.get("PARK")).equals(good.getNm_cd())){%> selected<%}%>><%= good.getNm()%>
                        </option>
                        <%}%>                    	
        		        </SELECT>
						<input type="text" name="park_cont" value="<%=reserv.get("PARK_CONT")%>" size="35" class=text style='IME-MODE: active'>
						(��Ÿ���ý� ����)
                    </td>
                </tr>		
            </table>
        </td>
    </tr>
    <%}%>    
    
    <tr> 
        <td align="right">
	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>			    
	        <a href='javascript:save();'><img src="/acar/images/center/button_conf.gif"  align="absmiddle" border="0"></a>
	    <%}%>		
	        <!--&nbsp;<a href='javascript:document.form1.reset();'><img src="/acar/images/center/button_cancel.gif" align="absmiddle" border="0"></a>-->
	        &nbsp;<a href="javascript:self.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>    
    <tr> 
        <td>&nbsp;</td>
    </tr> 
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ �������Ȳ</span> (����� 10����~����������)</td>
    <tr>	    
    <tr><td class=line2></td></tr>
    <%
    	Vector p_vt = pk_db.getPark_IO_list("", "1", "4", "", String.valueOf(reserv.get("CAR_NO")), rs_db.addDay(rc_bean.getRent_dt(), -10), rc_bean.getRet_plan_dt_d());
    %>  
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>  
                <tr>               
                    <td class=title width=10%>����</td>
                    <td class=title width=10%>�����</td>
                    <td class=title width=15%>����������</td>
                    <td class=title width=20%>������</td>
                    <td class=title width=10%>����</td>
                    <td class=title width=20%>��/��� �Ͻ�</td>
                    <td class=title width=15%>�����</td>
                </tr>     
                <%
                	if(p_vt.size() > 0 ){
            			for(int i=0; i < p_vt.size(); i++){            			
            				Hashtable p_ht = (Hashtable)p_vt.elementAt(i);
                %>           
                <tr>               
                    <td align="center">��������</td>
                    <td align="center">&nbsp;<%=p_ht.get("USERS_COMP")%></td>
                    <td align="center">&nbsp;<%=p_ht.get("DRIVER_NM")%></td>
                    <td align="center">&nbsp;<%=p_ht.get("PARK_PLACE")%></td>
                    <td align="center">&nbsp;<%if(p_ht.get("IO_GUBUN").equals("1")){%>�԰�<%}else if(p_ht.get("IO_GUBUN").equals("2")){%>���<%}%></td>
                    <td align="center">&nbsp;<%=p_ht.get("REG_DT")%></td>
                    <td align="center">&nbsp;<%=p_ht.get("PARK_MNG")%></td>
                </tr>                
                <%		}
            		}%>
            	<%	if(!String.valueOf(reserv2.get("CAR_NO")).equals("")){
            			p_vt = pk_db.getPark_IO_list("", "1", "4", "", String.valueOf(reserv2.get("CAR_NO")), rs_db.addDay(rc_bean.getRent_dt(), -10), rc_bean.getRet_plan_dt_d()); %>
            	<%
                		if(p_vt.size() > 0 ){%>
                <tr>
                    <td class=h colspan='7'></td>
                </tr>	
            	<%			for(int i=0; i < p_vt.size(); i++){            			
            					Hashtable p_ht = (Hashtable)p_vt.elementAt(i);
                %>           
                <tr>               
                    <td align="center">��������</td>
                    <td align="center"><%=p_ht.get("USERS_COMP")%></td>
                    <td align="center"><%=p_ht.get("DRIVER_NM")%></td>
                    <td align="center"><%=p_ht.get("PARK_PLACE")%></td>
                    <td align="center"><%if(p_ht.get("IO_GUBUN").equals("1")){%>�԰�<%}else if(p_ht.get("IO_GUBUN").equals("2")){%>���<%}%></td>
                    <td align="center"><%=p_ht.get("REG_DT")%></td>
                    <td align="center"><%=p_ht.get("PARK_MNG")%></td>
                </tr>                
                <%			}
                		}
            		}%>	
            </table>
        </td>
    </tr>            
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
