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
				if(fm.color.value == ''){ alert('�뿩����-������ �Է��Ͻʽÿ�.');fm.color.focus();return; }
				if(<%=base.getRent_dt()%> > 20161231 && '<%=base.getCar_gu()%>' == '1'){//����
					if(fm.in_col.value == ''){ alert('�뿩����-��������� �Է��Ͻʽÿ�.');fm.in_col.focus();return; }	
				}
				if(fm.car_ext.value == ''){ alert('�뿩����-��������� �Է��Ͻʽÿ�.');fm.car_ext.focus();return; }
				
				<%if(base.getCar_mng_id().equals("") || AddUtil.parseInt(base.getRent_dt()) > 20180208){%>
				
				<%if(ej_bean.getJg_g_7().equals("3") && !nm_db.getWorkAuthUser("������",user_id) && !nm_db.getWorkAuthUser("������������",user_id)){//������%>
					if(fm.ecar_loc_st.value == ''){	
						alert("������ ���ּ����� �����Ͻʽÿ�.");
						return;
					}
					//else{
					
					//1.����, 2.����, 3.�λ�, 4.����, 5.����, 6.��õ, 7.��õ, 8.����, 9.����, 10.�뱸
					
					//���� -> ���� ���
					/* if(fm.ecar_loc_st.value == '0'){
						fm.car_ext.value = '1';
					}
					//��õ,��� -> ���� ���
					if(fm.ecar_loc_st.value == '1'){
						fm.car_ext.value = '1';
					}
					//���� -> ���� ���
					if(fm.ecar_loc_st.value == '2'){
						fm.car_ext.value = '1';
					}
					//���� -> ���� ���
					if(fm.ecar_loc_st.value == '3'){
						fm.car_ext.value = '1';
					}
					//���� -> ���� ���
					if(fm.ecar_loc_st.value == '4'){
						fm.car_ext.value = '9';
					}
					//�뱸 -> �뱸 ���
					if(fm.ecar_loc_st.value == '5'){
						fm.car_ext.value = '10';
					}
					//�λ� -> ���� ���
					if(fm.ecar_loc_st.value == '6'){
						fm.car_ext.value = '1';
					}
					//����,�泲,���(��������) -> ���� ���
					if(fm.ecar_loc_st.value == '7'){
						fm.car_ext.value = '1';
					}
					//���(�뱸����) -> ���� ���
					if(fm.ecar_loc_st.value == '8'){
						fm.car_ext.value = '1';
					}
					//���,�泲 -> ���� ���
					if(fm.ecar_loc_st.value == '9'){
						fm.car_ext.value = '1';
					}
					//����,����(��������) -> ���� ���
					if(fm.ecar_loc_st.value == '10'){
						fm.car_ext.value = '1';
					} */
					
					// ���� ����ȭ����(�����: ����) �� ��� ������ �� �ּ����� ���� ���� ��õ���� ���. 2021.02.18.
					// ����ȭ���� �� ������ ���ּ��� ���� �ǵ������ ���. ����/��õ/����/����/�뱸/�λ� �� ������ ���ּ����� ��õ ���. 20210224
					// ����ȭ���� �� ������ ���ּ��� ���� �ǵ������ ���. ����/��õ/����/����/�뱸/�λ� �� ������ ���ּ����� �λ� ���. 20210520
<%-- 					<%if (cm_bean.getJg_code().equals("9133") || cm_bean.getJg_code().equals("9237") || cm_bean.getJg_code().equals("9015435") || cm_bean.getJg_code().equals("9025435") || cm_bean.getJg_code().equals("9015436") || cm_bean.getJg_code().equals("9015437") || cm_bean.getJg_code().equals("9025439") || cm_bean.getJg_code().equals("9025440")) {%> --%>
// 						fm.car_ext.value = '1';
<%-- 					<%} else{%> --%>
// 						if(fm.ecar_loc_st.value == '0'){	// ����
// 							fm.car_ext.value = '1';
// 						} else if(fm.ecar_loc_st.value == '1'){	// ��õ
// 							fm.car_ext.value = '7';
// 						} else if(fm.ecar_loc_st.value == '3'){	// ����
// 							fm.car_ext.value = '5';
// 						} else if(fm.ecar_loc_st.value == '4'){	// ����
// 							fm.car_ext.value = '9';
// 						} else if(fm.ecar_loc_st.value == '5'){	// �뱸
// 							fm.car_ext.value = '10';
// 						} else if(fm.ecar_loc_st.value == '6'){	// �λ�
// 							fm.car_ext.value = '3';
// 						} else{
// 							//fm.car_ext.value = '7';	// ������ ��õ
// 							fm.car_ext.value = '3';	// ������ ���� �λ����� ��� ó��.
// 						}
<%-- 					<%}%> --%>
					
					<%-- <%if (cm_bean.getJg_code().equals("3871") || cm_bean.getJg_code().equals("3313111") || cm_bean.getJg_code().equals("3313112") || cm_bean.getJg_code().equals("3313113") || cm_bean.getJg_code().equals("3313114")) {//20200221 ��3�� ����ε��%>
						// fm.car_ext.value = '1';
						fm.car_ext.value = '7'; // 20210216 �׽��� ��3 �ǵ������ ��õ���� ����.
					<%} else if (cm_bean.getJg_code().equals("9133") || cm_bean.getJg_code().equals("9237") || cm_bean.getJg_code().equals("9015435") || cm_bean.getJg_code().equals("9025435") || cm_bean.getJg_code().equals("9015436") || cm_bean.getJg_code().equals("9015437") || cm_bean.getJg_code().equals("9025439") || cm_bean.getJg_code().equals("9025440")) {//20200313 �����Ϸ�Ʈ��, ����EV�� �뱸���%>
						//fm.car_ext.value = '7';
						fm.car_ext.value = '1';
					<%}%> --%>
// 				}
				<%}%>
				
				<%if(ej_bean.getJg_g_7().equals("4") && !nm_db.getWorkAuthUser("������",user_id) && !nm_db.getWorkAuthUser("������������",user_id)){//������%>
				if(fm.hcar_loc_st.value == ''){
					alert("������ ���ּ����� �����Ͻʽÿ�.");
					return;			
				}
				/* else{
					fm.car_ext.value = '1';
				} */
				//��õ -> ��õ ���
// 				if(fm.hcar_loc_st.value == '1'){	
// 					fm.car_ext.value = '7';
// 				}
// 				//���� ���� -> ������ ���� ���
// 				if(fm.hcar_loc_st.value == '3'  && fm.car_st.value == '3'){	
// 					fm.car_ext.value = '5';
// 				}
// 				//����/����/���� -> ���� ���
// 				if(fm.hcar_loc_st.value == '4'){	
// 					fm.car_ext.value = '9';
// 				}
// 				//�λ�/���/�泲 -> �λ� ���
// 				if(fm.hcar_loc_st.value == '6'){	
// 					fm.car_ext.value = '3';
// 				}
// 				//20190701 ������ ��õ���
// 				//fm.car_ext.value = '7';
// 				fm.car_ext.value = '7'; //20191206 �������� ��� ��õ
				//fm.car_ext.value = '1'; //20200324 �������� ��� ��õ -> ����� ���
				<%}%>				
		
				<%-- <%if(ej_bean.getJg_b().equals("3")||ej_bean.getJg_b().equals("4")||ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//ģȯ����-��������%>
				if(fm.eco_e_tag.value == ''){	
					alert("�������ｺƼĿ �߱�(�����ͳ� �̿� �����±�)�� �����Ͻʽÿ�.");
					return;
				}		
				/* if(fm.eco_e_tag.value == '1'){
					fm.car_ext.value = '1'; //�������ｺƼĿ �߱޽� ������
				} */
				
					<%if (!nm_db.getWorkAuthUser("������",user_id) && !nm_db.getWorkAuthUser("������������",user_id)) {%>
						<%if(ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//ģȯ����:��������%>
						if(fm.eco_e_tag.value == '1'){
							alert("������/�������� ���� �������ｺƼĿ �߱�(�����ͳ� �̿� �����±�)�� �Ұ��մϴ�.");
							return;
						}
						<%}else{%>
						if(fm.eco_e_tag.value == '1'){
							fm.car_ext.value = '1'; //�������ｺƼĿ �߱޽� ������
						}
						<%}%>
					<%}%>
				
				<%}%> --%>
				
				<%}%>
						
				
				if(fm.pur_color.value != ''){
					if(fm.old_color.value != fm.color.value || fm.old_in_col.value != fm.in_col.value || fm.old_garnish_col.value != fm.garnish_col.value){
						alert('Ư�ǹ����� �ִ� ����('+fm.pur_color.value+')�ϰ� �뿩����-������ �ٸ��ϴ�. ���� ������̸� ������ ���¾�ü����-��ü���������� ����(����) ���� �����Ͻʽÿ�.');
					}				
				}
				
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
  <input type='hidden' name='from_page2'	 	value='/fms2/lc_rent/lc_b_s_8_1.jsp'>
  <input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="now_stat"		value="<%=now_stat%>">
  <input type='hidden' name="san_st"			value="<%=san_st%>">
  <input type='hidden' name="fee_rent_st"	value="<%=fee_rent_st%>">  
  <input type='hidden' name="idx"	value="">
  <input type='hidden' name="firm_nm"			value="<%=client.getFirm_nm()%>">
     
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
                    <td class='title' width='13%'>����</td>
                    <td>&nbsp;<input type='text' name='color' size='45' maxlength='100' class='text' value='<%=car.getColo()%>'>
					              &nbsp;&nbsp;&nbsp;(�������(��Ʈ): <input type='text' name="in_col" size='20' class='text' value='<%=car.getIn_col()%>'> )
					              &nbsp;&nbsp;&nbsp;(���Ͻ�: <input type='text' name="garnish_col" size='20' class='text' value='<%=car.getGarnish_col()%>'> )
					              
		              <input type="hidden" name="old_color" value="<%=car.getColo()%>">
					  <input type="hidden" name="old_in_col" value="<%=car.getIn_col()%>">
					  <input type="hidden" name="old_garnish_col" value="<%=car.getGarnish_col()%>">
        			</td>
                </tr>
                <%if(ej_bean.getJg_g_7().equals("3")){//������%>	
                <tr>
                    <td class='title'>������ ���ּ���</td>
                    <td>&nbsp;
                        <select name="ecar_loc_st">
                    	  <option value=""  <%if(pur.getEcar_loc_st().equals(""))%>selected<%%>>����</option>
                    	  <%for(int i = 0 ; i < code34_size ; i++){
                            CodeBean code = code34[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(pur.getEcar_loc_st().equals(code.getNm_cd())){%>selected<%}%> <%if(Integer.parseInt(cm_bean.getJg_code()) > 8000000 && (code.getNm_cd().equals("12") || code.getNm_cd().equals("13"))){ %>style='display: none;'<%} %>><%= code.getNm()%></option>
                        <%}%>        
                      </select>
        			      </td>
                </tr>
                <%}%>
                <%if(ej_bean.getJg_g_7().equals("4")){//������%>	
                <tr>
                    <td class='title'>������ ���ּ���</td>
                    <td>&nbsp;
                        <select name="hcar_loc_st">
                    	  <option value=""  <%if(pur.getHcar_loc_st().equals(""))%>selected<%%>>����</option>
                    	  <%for(int i = 0 ; i < code37_size ; i++){
                            CodeBean code = code37[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(pur.getHcar_loc_st().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>        
                      </select>
        			      </td>
                </tr>
                <%}%>                
                	<input type="hidden" name="eco_e_tag" id="eco_e_tag" value="<%=car.getEco_e_tag()%>">		
                <tr>
                    <td class='title'>�����μ���</td>
                    <td>&nbsp;
                        <select name="udt_st">
                        <option value=''>����</option>
                    	  <%for(int i = 0 ; i < code35_size ; i++){
                            CodeBean code = code35[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(pur.getUdt_st().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
                      </select>
        			        &nbsp; �μ��� Ź�۷� :
        			        <input type='text' name='cons_amt1' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(pur.getCons_amt1())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        					    �� (���μ��� ���� ���� �Է��ϼ���.)
        			</td>
                </tr>
                <tr>
                    <td width='13%' class='title'>�������</td>
                    <td>&nbsp;
                      <select name="car_ext" id="car_ext">
                        	<option value=''>����</option>
                    	  <%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(car.getCar_ext().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
                      </select>
                    </td>
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
	    <td align="right"><%if(!san_st.equals("��û") ||   auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('8_1')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%>
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
