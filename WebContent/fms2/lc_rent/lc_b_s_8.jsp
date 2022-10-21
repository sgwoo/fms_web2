<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.user_mng.*, acar.car_office.* "%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();

	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")  ==null?acar_br:request.getParameter("br_id");
	String auth_rw = rs_db.getAuthRw(user_id, "01", "01", "08");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"" :request.getParameter("t_wd");
	String andor = request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String from_page2 = request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st = request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String now_stat = request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	String san_st = request.getParameter("san_st")==null?"":request.getParameter("san_st");
	String fee_rent_st = request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
		
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//Ư�ǰ������
	Hashtable pur_com = cod.getPurComCont(rent_mng_id, rent_l_cd);	
		
	//�ܰ�����NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
  	//�����������
  	CodeBean[] code32 = c_db.getCodeAll3("0032");
  	int code32_size = code32.length;
  
  	//������ ���ּ���
  	CodeBean[] code34 = c_db.getCodeAll3("0034");
  	int code34_size = code34.length;	
  
  	//������ ���ּ���
  	CodeBean[] code37 = c_db.getCodeAll3("0037");
  	int code37_size = code37.length;	
  
  	//�����μ�����
  	CodeBean[] code35 = c_db.getCodeAll3("0035");
  	int code35_size = code35.length;
	
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
	//����
	function update(idx){
		var fm = document.form1;
		if(<%=base.getRent_dt()%> > 20070831){
						
				// ��޽��� �߰� 2017.12.26
				if(fm.tint_s_yn.checked == true && fm.tint_sn_yn.checked == true && fm.tint_ps_yn.checked == true){
					alert('�������(�⺻��), ������� �̽ð� ����, ��޽���(��������) �� �ϳ��� üũ�ϼ���.'); fm.tint_s_yn.focus(); return;
				}
				if(fm.tint_s_yn.checked == true && fm.tint_ps_yn.checked == true){
					alert('�������(�⺻��)�� ��޽���(��������) �� �ϳ��� üũ�ϼ���.'); fm.tint_s_yn.focus(); return;
				}
				if(fm.tint_s_yn.checked == true && fm.tint_sn_yn.checked == true){
					alert('�������(�⺻��)�� ������� �̽ð� ���� �� �ϳ��� üũ�ϼ���.'); fm.tint_s_yn.focus(); return;
				}
				if(fm.tint_sn_yn.checked == true && fm.tint_ps_yn.checked == true){
					alert('������� �̽ð� ���ΰ� ��޽���(��������) �� �ϳ��� üũ�ϼ���.'); fm.tint_ps_yn.focus(); return;
				}
				if(fm.tint_ps_yn.checked == true && fm.tint_ps_amt.value < 1){
					alert('��޽��� �ݾ��� �Է��ϼ���.'); fm.tint_ps_amt.focus(); return;
				}// end
				if(fm.tint_s_yn.checked == true && toInt(fm.tint_s_per.value) < 50 && '<%=ej_bean.getJg_w()%>' != '1'){
					//alert('�뿩����-��ǰ-��������� �������� �������� 50% �̻� �����մϴ�.');fm.tint_s_per.focus();return;
				}
				if(fm.tint_bn_yn.checked == true && fm.tint_bn_nm.value == ''){
					alert('���ڽ� ������ ���� ������ �����Ͻʽÿ�.'); fm.tint_bn_nm.focus(); return;
				}
				
				var prev_new_license_plate = '<%=car.getNew_license_plate()%>';
				if(prev_new_license_plate == '1' || prev_new_license_plate == '2'){
					prev_new_license_plate = '1';
				} else {
					prev_new_license_plate = '0';
				}
				fm.prev_new_license_plate.value = prev_new_license_plate;

		}
		
		fm.idx.value = idx;
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='lc_b_s_a.jsp';		
			fm.target='_self';
			fm.submit();
		}							
	}
	
	
	
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body>
<form action='lc_b_s_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" value="<%=auth_rw%>">
  <input type='hidden' name="user_id" value="<%=user_id%>">
  <input type='hidden' name="br_id"   value="<%=br_id%>">
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='from_page'	 	value='<%=from_page%>'>  
  <input type='hidden' name='from_page2'	 	value='/fms2/lc_rent/lc_b_s_8.jsp'>
  <input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="now_stat"		value="<%=now_stat%>">
  <input type='hidden' name="san_st"			value="<%=san_st%>">
  <input type='hidden' name="fee_rent_st"	value="<%=fee_rent_st%>">  
  <input type='hidden' name="idx"	value="">
  <input type='hidden' name="firm_nm"			value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="prev_new_license_plate"		value="">
     
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td colspan='2'>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>�̰���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩����</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class='line'> 			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	
                <tr>
                    <td width='13%' class='title'>����</td>
                    <td <% if (base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001")) { %> width='10%' <% } else { %> colspan="3" <% } %>>&nbsp;
                      	<input type='text' name="sun_per" value='<%=car.getSun_per()%>' size="4" maxlength="4" class='text'> %                      
                      	<%if (car.getHipass_yn().equals("")) { // 20181012 �����н����� (������ ������ ���� select���� input���� ���� ó��)%>
							<input type="hidden" name="hipass_yn" value="">
						<%} else {%>
							<input type="hidden" name="hipass_yn" value="<%=car.getHipass_yn()%>">
						<%}%>
												
                    </td>
                    <% if (base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001")) { %>
	                    <td width='10%' class='title'>��縵ũ����</td>
	                    <td>&nbsp;
	                        <select name="bluelink_yn">
	                            <option value='' <%if(car.getBluelink_yn().equals(""))%>selected<%%>>����</option>
	                            <option value='Y' <%if(car.getBluelink_yn().equals("Y"))%>selected<%%>>����</option>
	                            <option value='N' <%if(car.getBluelink_yn().equals("N"))%>selected<%%>>����</option>
	                        </select>
	                        <span style="font-size : 8pt; letter-spacing: -0.6px;">&nbsp;�� �������ý� ��縵ũ ���� �ȳ��� �˸���߼�(�����ٻ�����)</span>
	                    </td>
                    <% }else{ %>
                    <input type="hidden" name="bluelink_yn" value="<%=car.getBluelink_yn()%>">
                    <% } %>
                </tr>
                <tr>
                    <td class='title'><span class="title1">������߰�����</span></td>
                    <td colspan="5">&nbsp;
                        <input type='text' name='add_opt' size='65' class="text" value='<%=car.getAdd_opt()%>'>
        				        &nbsp;<input type='text' name='add_opt_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(car.getAdd_opt_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        					      ��&nbsp;<span style="font-size : 8pt;"><font color="#666666">(�ΰ������Աݾ�,�����ݿ���,LPGŰƮ����,�׺���̼ǵ�)</font></span>
                    </td>
                </tr>
                <tr>
                    <td class='title'><span class="title1">�����ݿ���ǰ</span></td>
                    <td colspan="5">&nbsp;
                        <label><input type="checkbox" name="tint_b_yn" value="Y" <%if(car.getTint_b_yn().equals("Y")){%>checked<%}%>> 2ä�� ���ڽ�</label>
                        &nbsp;
                        <label><input type="checkbox" name="tint_s_yn" value="Y" <%if(car.getTint_s_yn().equals("Y")){%>checked<%}%>> ���� ����(�⺻��)</label>,
                        ���ñ��������� :
                        <input type='text' name="tint_s_per" value='<%=car.getTint_s_per()%>' size="4" maxlength="4" class='text'>
        	              % 
      		              &nbsp;
      		            <label><input type="checkbox" name="tint_ps_yn" value="Y" <%if(car.getTint_ps_yn().equals("Y")){%>checked<%}%>> ��޽���(��������)</label>
      		            &nbsp;&nbsp;���� <input type="text" name="tint_ps_nm" class='text' size="9" value='<%=car.getTint_ps_nm()%>'>
      		            &nbsp; ��ǰ�� ���ޱݾ� <input type="text" name="tint_ps_amt" class='num' size="9" value='<%=AddUtil.parseDecimal(car.getTint_ps_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);'> �� (�ΰ�������)
      		            <br>
					      &nbsp;
                        <label><input type="checkbox" name="tint_sn_yn" value="Y" <%if(car.getTint_sn_yn().equals("Y")){%>checked<%}%>> ������� �̽ð� ����</label>                         
					      &nbsp;
                        <label><input type="checkbox" name="tint_bn_yn" value="Y" <%if(car.getTint_bn_yn().equals("Y")){%>checked<%}%>> ���ڽ� ������ ����
                  		&nbsp; ���λ��� : 
                  		<select name="tint_bn_nm">
                  		<option value=""  <%if (car.getTint_bn_nm().equals("")){%>selected<%}%>>����</option>
                  		<option value="2" <%if (car.getTint_bn_nm().equals("2")){%>selected<%}%>>������</option>
                   		<option value="1" <%if (car.getTint_bn_nm().equals("1")){%>selected<%}%>>��Ʈ��ķ</option>                   		
                   		</select>
                        </label>                         
					      &nbsp;
                        <label><input type="checkbox" name="tint_cons_yn" value="Y" <%if(car.getTint_cons_yn().equals("Y")){%>checked<%}%>> �߰�Ź�۷�� </label>                          
					      &nbsp;
					      <input type="text" name="tint_cons_amt" class='num' size="9" value='<%=AddUtil.parseDecimal(car.getTint_cons_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);'> ��
					      &nbsp;
                        <label <%if(!car.getTint_n_yn().equals("Y")){%>style="display: none;"<%}%>><input type="checkbox" name="tint_n_yn" value="Y" <%if(car.getTint_n_yn().equals("Y")){%>checked<%}%>> ��ġ�� ������̼�</label>
                      <%if(ej_bean.getJg_g_7().equals("3")){//������%>
      		      &nbsp;
                      <label><input type="checkbox" name="tint_eb_yn" value="Y" <%if(car.getTint_eb_yn().equals("Y")){%>checked<%}%>> �̵��� ������(������)</label>
                      <%}%>           
                      &nbsp;
                      <%if( user_id.equals("000077") || !( (Integer.parseInt(ej_bean.getSh_code()) > 9018110 && Integer.parseInt(ej_bean.getSh_code()) < 9018999) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")
                    		  || cm_bean.getCar_comp_id().equals("0044") || cm_bean.getCar_comp_id().equals("0007") || cm_bean.getCar_comp_id().equals("0025") || cm_bean.getCar_comp_id().equals("0033") || cm_bean.getCar_comp_id().equals("0048")) ){ %>
                      ��ȣ�Ǳ���
                      <!-- ������ȣ�ǽ�û -->
                   	<select name="new_license_plate">
                   		<option value="1" <%if (car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")) {%>selected<%}%>>����</option>
                   		<option value="0" <%if (!(car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2"))) {%>selected<%}%>>����</option>
                   	</select>             
                   	<%} %>
                    </td>
                </tr>   
                <tr>
                    <td class='title'><span class="title1">����ǰ��</span></td>
                    <td colspan="5">&nbsp;
                        <input type='text' name='extra_set' size='65' class="text" value='<%=car.getExtra_set()%>'>
        				        &nbsp;<input type='text' name='extra_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(car.getExtra_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        					      ��&nbsp;<span style="font-size : 8pt;"><font color="#666666">(�ΰ������Աݾ�,�����̹ݿ���)</font></span><br>
        					      &nbsp;<input type="checkbox" name="serv_b_yn" value="Y" <%if(car.getServ_b_yn().equals("Y")){%>checked<%}%>> ���ڽ� (2015��8��1�Ϻ���)
        					      <%if(ej_bean.getJg_g_7().equals("3")){%>
									&nbsp;<input type="checkbox" name="serv_sc_yn" value="Y" <%if(car.getServ_sc_yn().equals("Y")){%>checked<%}%>> ������������
								  <%} %>
                    </td>
                </tr>		  
                <tr>
                    <td class='title'>���</td>
                    <td colspan="5">&nbsp;
                        <textarea rows='5' cols='90' name='remark'><%=car.getRemark()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr>
    <%if(!String.valueOf(pur_com.get("RENT_L_CD")).equals("") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("null") && !String.valueOf(pur_com.get("USE_YN_ST")).equals("����")){%>
	<tr>
        <td><font color='red'>�� Ư�ǹ������� ��Ϻ��Դϴ�. ������ ������ ��� ���¾�ü����-��ü���������� ��ຯ�� ó���Ͻʽÿ�.</font></td>
    </tr> 
    <input type="hidden" name="pur_color" value="<%=pur_com.get("R_COLO")%>">   
    <%}else{ %>
    <input type="hidden" name="pur_color" value="">
	<%} %>	    
	<tr>
	    <td align="right"><%if(!san_st.equals("��û") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('8')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%>
	    	&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
    	</td>
	<tr>	
</table>
  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

<script type="text/javascript">
	
</script>
</body>
</html>
