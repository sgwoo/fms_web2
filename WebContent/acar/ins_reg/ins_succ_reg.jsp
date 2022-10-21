<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.insur.*, acar.car_register.*"%>
<jsp:useBean id="ins" class="acar.insur.InsurBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//����� ������ȣ
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//����� �Ҽӿ�����
	
	String o_c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String o_ins_st = request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "06", "01");
	
	InsDatabase ai_db = InsDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	ins = ai_db.getIns(o_c_id, o_ins_st);
	
	//��������
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(o_c_id);
	
	//����� ����Ʈ
	InsComBean ic_r [] = c_db.getInsComAll();
	int ic_size = ic_r.length;
%> 
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save(){
		var fm = document.form1;
		if(fm.o_c_id.value == '' || fm.o_ins_st.value == '' || fm.car_mng_id.value == ''){ alert('������ �����Ͻʽÿ�.'); return; }
		
		if(!confirm('�°��Ͻðڽ��ϱ�?')){	return;	}
		
		fm.target = 'i_no';
		fm.action = 'ins_succ_reg_a.jsp';
		fm.submit();
	}
	
	//�˻��ϱ�
	function search(){
		var fm = document.form1;	
		window.open("about:blank", "SEARCH", "left=100, top=100, width=800, height=500, scrollbars=yes");
		var fm = document.form1;
		fm.action = "search_succ.jsp";		
		fm.target = "SEARCH";
		fm.submit();		
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function enter(idx) {
		var fm = document.form1;
		var keyValue = event.keyCode;
		if (keyValue =='13'){
			if(idx == 1)  fm.vins_pcp_amt.focus();
			if(idx == 2)  fm.vins_gcp_amt.focus();
			if(idx == 3)  fm.vins_bacdt_amt.focus();
			if(idx == 4)  fm.vins_canoisr_amt.focus();
			if(idx == 5)  fm.vins_cacdt_cm_amt.focus();
			if(idx == 6)  fm.vins_spe.focus();
			if(idx == 7)  fm.vins_spe_amt.focus();
		}
	}
	
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='ins_reg_a.jsp'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
<input type='hidden' name="o_c_id" value='<%=o_c_id%>'>
<input type='hidden' name="o_ins_st" value='<%=o_ins_st%>'>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������ > ������� > <span class=style5>
						����°���</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td></td>
	</tr>    	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>������ȣ</td>
                    <td width=15%><%=cr_bean.getCar_no()%></td>
                    <td class=title width=10%>����</td>
                    <td width=15%><%=cr_bean.getCar_nm()%></td>
                    <td class=title width=10%>���ʵ����</td>
                    <td width=15%><%=cr_bean.getInit_reg_dt()%></td>
                    <td class=title width=10%>�����ȣ</td>
                    <td width=15%><%=cr_bean.getCar_num()%></td>
                </tr>		
            </table>
        </td>
    </tr>	
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�°�����</span> &nbsp;&nbsp;<a href='javascript:search()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=/acar/images/center/button_search_s.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr><input type='hidden' name="car_mng_id" value=''> 
                    <td class=title width=10%>������ȣ</td>
                    <td width=15%><input type='text' name='car_no' value='' size='15' class='whitetext'></td>
                    <td class=title width=10%>����</td>
                    <td width=15%><input type='text' name='car_nm' value='' size='20' class='whitetext'></td>
                    <td class=title width=10%>���ʵ����</td>
                    <td width=15%><input type='text' name='init_reg_dt' value='' size='12' class='whitetext'></td>
                    <td class=title width=10%>�����ȣ</td>
                    <td width=15%><input type='text' name='car_num' value='' size='20' class='whitetext'></td>
                </tr>		
            </table>
        </td>
    </tr>		
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>��ϱ���</td>
                    <td width=15%>
                      <select name='ins_st'>
                        <option value="1">�ű�</option>
                        <option value="2">����</option>
                      </select>			
                    </td>
                    <td class=title width=10%>��ϻ���</td>
                    <td width=15%>
                      <select name='reg_cau'>
                        <option value=''>===�ű�===</option>
                        <option value='1' <%if(ins.getReg_cau().equals("1")){%>selected<%}%>>1. ����</option>
                        <option value='2' <%if(ins.getReg_cau().equals("2")){%>selected<%}%>>2. �뵵����</option>
                        <option value='5' <%if(ins.getReg_cau().equals("5")){%>selected<%}%>>3. ��������</option>				
                        <option value=''>===����===</option>				
                        <option value='3' <%if(ins.getReg_cau().equals("3")){%>selected<%}%>>1. �㺸����</option>
                        <option value='4' <%if(ins.getReg_cau().equals("4")){%>selected<%}%>>2. ����</option>				
                      </select>
                    </td>
                    <td class=title width=10%>�㺸����</td>
                    <td width=15%>
                      <select name='ins_kd'>
                        <option value='1' <%if(ins.getIns_kd().equals("1")){%>selected<%}%>>���㺸</option>
                        <option value='2' <%if(ins.getIns_kd().equals("2")){%>selected<%}%>>å�Ӻ���</option>
                      </select>
                    </td>
                    <td class=title width=10%>�������</td>
                    <td width=15%>
                      <select name='ins_sts'>
                        <option value='1' <%if(ins.getIns_sts().equals("1")){%>selected<%}%>>��ȿ</option>
                        <!--<option value='2' <%if(ins.getIns_sts().equals("2")){%>selected<%}%>>����</option>
                        <option value='3' <%if(ins.getIns_sts().equals("3")){%>selected<%}%>>�ߵ�����</option>
                        <option value='5' <%if(ins.getIns_sts().equals("5")){%>selected<%}%>>�°�</option>-->
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>����ȸ��</td>
                    <td> 
                      <select name='ins_com_id'>
                        <%if(ic_size > 0){
        					for(int i = 0 ; i < ic_size ; i++){
        						InsComBean ic = ic_r[i];%>
                        <option value="<%=ic.getIns_com_id()%>" <%if(ins.getIns_com_id().equals(ic.getIns_com_id())){%>selected<%}%>><%=ic.getIns_com_nm()%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td class=title>����ȣ</td>
                    <td> 
                      <input type='text' name='ins_con_no' size='25' value='<%=ins.getIns_con_no()%>' class='text'>
                    </td>
                    <td class=title>�����</td>
                    <td> 
                      <input type='text' name='conr_nm' value='<%=ins.getConr_nm()%>' size='10' class='text'>
                    </td>
                    <td class=title>�Ǻ�����</td>
                    <td> 
                      <input type='text' name='con_f_nm' value='<%=ins.getCon_f_nm()%>' size='10' class='text'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>����Ⱓ</td>
                    <td colspan="3"> 
                      <input type="text" name="ins_start_dt" value="<%=AddUtil.ChangeDate2(ins.getIns_start_dt())%>" size="11" class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                      &nbsp;24��&nbsp;&nbsp;~ &nbsp;&nbsp; 
                      <input type="text" name="ins_exp_dt" value="<%=AddUtil.ChangeDate2(ins.getIns_exp_dt())%>" size="11" class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                      &nbsp;24�� </td>
                    <td class=title>��������</td>
                    <td> 
                      <select name='car_use'>
                        <option value='1' <%if(ins.getCar_use().equals("1")){%>selected<%}%>>������</option>
                        <option value='2' <%if(ins.getCar_use().equals("2")){%>selected<%}%>>������</option>
                      </select>
                    </td>
                    <td class=title>���ɹ���</td>
                    <td> 
                      <select name='age_scp'>
                        <option value='1' <%if(ins.getAge_scp().equals("1")){%>selected<%}%>>21���̻�</option>
                        <option value='4' <%if(ins.getAge_scp().equals("4")){%>selected<%}%>>24���̻�</option>
                        <option value='2' <%if(ins.getAge_scp().equals("2")){%>selected<%}%>>26���̻�</option>
                        <option value='3' <%if(ins.getAge_scp().equals("3")){%>selected<%}%>>������</option>
                        <option value=''>=�Ǻ����ڰ�=</option>				
                        <option value='5' <%if(ins.getAge_scp().equals("5")){%>selected<%}%>>30���̻�</option>				
                        <option value='6' <%if(ins.getAge_scp().equals("6")){%>selected<%}%>>35���̻�</option>				
                        <option value='7' <%if(ins.getAge_scp().equals("7")){%>selected<%}%>>43���̻�</option>						
						<option value='8' <%if(ins.getAge_scp().equals("8")){%>selected<%}%>>48���̻�</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>�����</td>
                    <td colspan="3"> 
                      <input type='checkbox' name='air_ds_yn' value='Y' <%if(ins.getAir_ds_yn().equals("Y")){%>checked<%}%>>
                      ������ 
                      <input type='checkbox' name='air_as_yn' value='Y' <%if(ins.getAir_as_yn().equals("Y")){%>checked<%}%>>
                      ������</td>
                    <td class='title'>���԰����</td>
                    <td> 
                      <input type='text' name='car_rate' size='5' maxlength='30' value='<%=ins.getCar_rate()%>' class='text'>
                      % </td>
                    <td class='title'>����������</td>
                    <td> 
                      <input type='text' name='ext_rate' size='5' maxlength='30' value='<%=ins.getExt_rate()%>' class='text'>
                      % </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr><tr></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title colspan="2">�㺸</td>
                    <td class=title width=50%>���Աݾ�</td>
                    <td class=title width=25%>�����</td>
                </tr>
                <tr> 
                    <td class=title width=10%>å�Ӻ���</td>
                    <td class=title width=15%>���ι��</td>
                    <td>�ڹ�� ����ɿ��� ���� �ݾ�</td>
                    <td align="center"> 
                      <input type='text' size='10' name='rins_pcp_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getRins_pcp_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);' onKeyDown="javasript:enter(1)">
                      ��</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr><tr></tr>
    <tr id=tr1 style="display:<%if(ins.getIns_kd().equals("2")) {%>none<%}else{%>''<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title rowspan="9" width=10%>���Ǻ���</td>
                    <td class=title colspan="2">���ι��</td>
                    <td> 
                      <select name='vins_pcp_kd'>
                        <option value='1' <%if(ins.getVins_pcp_kd().equals("1")){%>selected<%}%>>����</option>
                        <option value='2' <%if(ins.getVins_pcp_kd().equals("2")){%>selected<%}%>>����</option>
                      </select>
                    </td>
                    <td align="center" > 
                      <input type='text' size='10' name='vins_pcp_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_pcp_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);' onKeyDown="javasript:enter(2)">
                      ��</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">�빰���&nbsp;&nbsp;</td>
                    <td> 
                      <select name='vins_gcp_kd'>
                        <option value='6' <%if(ins.getVins_gcp_kd().equals("6")){%>selected<%}%>>5���</option>
						<option value='8' <%if(ins.getVins_gcp_kd().equals("8")){%>selected<%}%>>3���</option>
						<option value='7' <%if(ins.getVins_gcp_kd().equals("7")){%>selected<%}%>>2���</option>
						<option value='3' <%if(ins.getVins_gcp_kd().equals("3")){%>selected<%}%>>1���</option>
                        <option value='4' <%if(ins.getVins_gcp_kd().equals("4")){%>selected<%}%>>5000����&nbsp;&nbsp;&nbsp;</option>
                        <option value='1' <%if(ins.getVins_gcp_kd().equals("1")){%>selected<%}%>>3000����</option>
                        <option value='2' <%if(ins.getVins_gcp_kd().equals("2")){%>selected<%}%>>1500����</option>
                        <option value='5' <%if(ins.getVins_gcp_kd().equals("5")){%>selected<%}%>>1000����</option>				
                      </select>
                      (1����)</td>
                    <td align="center"> 
                      <input type='text' size='10' class='num' name='vins_gcp_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_gcp_amt()))%>' onBlur='javascript:this.value=parseDecimal(this.value);' onKeyDown="javasript:enter(3)">
                      ��</td>
                </tr>
                <tr> 
                    <td class=title rowspan="2" colspan="2">�ڱ��ü���</td>
                    <td> 
                      <select name='vins_bacdt_kd'>
                        <option value="1" <%if(ins.getVins_bacdt_kd().equals("1")){%>selected<%}%>>3���</option>
                        <option value="2" <%if(ins.getVins_bacdt_kd().equals("2")){%>selected<%}%>>1��5õ����</option>
                        <option value="6" <%if(ins.getVins_bacdt_kd().equals("6")){%>selected<%}%>>1���</option>
                        <option value="5" <%if(ins.getVins_bacdt_kd().equals("5")){%>selected<%}%>>5000����</option>
                        <option value="3" <%if(ins.getVins_bacdt_kd().equals("3")){%>selected<%}%>>3000����</option>
                        <option value="4" <%if(ins.getVins_bacdt_kd().equals("4")){%>selected<%}%>>1500����</option>
                        <option value="9" <%if(ins.getVins_bacdt_kd().equals("9")){%>selected<%}%>>�̰���</option>
                      </select>
                      (1�δ���/����)</td>
                    <td align="center" rowspan="2"> 
                      <input type='text' size='10' name='vins_bacdt_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_bacdt_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);' onKeyDown="javasript:enter(4)">
                      ��</td>
                </tr>
                <tr> 
                    <td> 
                      <select name='vins_bacdt_kc2'>
                        <option value="1" <%if(ins.getVins_bacdt_kc2().equals("1")){%>selected<%}%>>3���</option>
                        <option value="2" <%if(ins.getVins_bacdt_kc2().equals("2")){%>selected<%}%>>1��5õ����</option>
                        <option value="6" <%if(ins.getVins_bacdt_kc2().equals("6")){%>selected<%}%>>1���</option>
                        <option value="5" <%if(ins.getVins_bacdt_kc2().equals("5")){%>selected<%}%>>5000����</option>
                        <option value="3" <%if(ins.getVins_bacdt_kc2().equals("3")){%>selected<%}%>>3000����</option>
                        <option value="4" <%if(ins.getVins_bacdt_kc2().equals("4")){%>selected<%}%>>1500����</option>
                      </select>
                      (1�δ�λ�)</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">������������</td>
                    <td> 
                      <!--
                      <select name='vins_canoisr_kd'>
                        <option value="" ></option>
                        <option value="1">3���</option>
                        <option value="7">2���</option>
                        <option value="2">1��5õ����</option>
                        <option value="6">1���</option>
                        <option value="5">5000����</option>
                        <option value="3">3000����</option>
                        <option value="4">1500����</option>
                      </select>
                      (�Ǻ����� 1�δ� �ְ�)-->
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='vins_canoisr_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_canoisr_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);' onKeyDown="javasript:enter(5)">
                      ��</td>
                </tr>
                <tr>
                    <td class=title rowspan="3" width=9%>�ڱ���������</td>
                    <td class=title width=6%>�Ƹ���ī</td>
                    <td width=50%><!--<font color="#666666">���������: <%//=AddUtil.parseDecimal(String.valueOf(cont.get("CAR_JA")))%>��</font>--></td>
                    <td align="center" rowspan="3" width=25%> 
                      <input type='text' size='10' name='vins_cacdt_cm_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_cm_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);' onKeyDown="javasript:enter(6)">
                      ��</td>
                </tr>
                <tr>
                    <td class=title rowspan="2">�����</td>
                    <td>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� 
                      <input type='text' size='6' name='vins_cacdt_car_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_car_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ����</td>
                </tr>
                <tr> 
                    <td>�ڱ�δ�� 
                    <input type='text' size='6' name='vins_cacdt_me_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_me_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    ����</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">Ư��</td>
                    <td> 
                      <input type='text' size='50' name='vins_spe' value='<%=ins.getVins_spe()%>' class='text' style='IME-MODE: active' onKeyDown="javasript:enter(7)">
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='vins_spe_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_spe_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 	
        <td align="right">
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href='javascript:save()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
        <%}%>	  
	    </td>
    </tr>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</form>
</body>
</html>
