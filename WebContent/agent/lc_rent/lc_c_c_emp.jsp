<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.car_register.*,acar.client.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.doc_settle.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%

	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//1. �� ---------------------------
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());

	//2. �ڵ���--------------------------
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	
	

	//3. �뿩-----------------------------
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//������ �����
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//���ຸ������
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//����ǰ��
	DocSettleBean doc = d_db.getDocSettleCommi("1", rent_l_cd);
	
	
	//4. ����----------------------------
	
	
	
	
	
	
	
	from_page = "/agent/lc_rent/lc_c_c_emp.jsp";
	
	String valus = 	"?user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//����
	function update(st, rent_st){
		if(st == 'grt_amt' || st == 'pp_amt' || st == 'ifee_amt' || st == 'fee_amt' || st == 'inv_amt'){
			window.open("/agent/lc_rent/cng_item.jsp<%=valus%>&cng_item="+st+"&rent_st="+rent_st, "CHANGE_ITEM", "left=100, top=100, width=1050, height=650");
		}else{
			var height = 500;
			if(st == 'car') 				height = 350;
			else if(st == 'car_amt') 		height = 350;
			else if(st == 'insur') 			height = 500;
			else if(st == 'gi') 			height = 250;
			window.open("/agent/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st+"&rent_st="+rent_st, "CHANGE_ITEM", "left=50, top=50, width=1050, height="+height+", scrollbars=yes");
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
<body leftmargin="15">
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>">
  <input type='hidden' name="car_mng_id" 		value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="client_id" 		value="<%=base.getClient_id()%>">

<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������-������� <%if(user_id.equals("000000") || base.getBus_id().equals(user_id)){%><a href="javascript:update('emp1','')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a><%}%><font color="#CCCCCC"> ( ȸ��������� : �������-������� ���� )</font></span></td>
	</tr>
    <tr id=tr_emp_bus style="display:<%if(base.getCar_gu().equals("1")){%>''<%}else{%>none<%}%>"> 	
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr>
            	    <td class=line2 style='height:1'></td>
            	</tr>
              <tr>
                <td class='title'>��������</td>
                <td colspan='5'>&nbsp;
                  <%String pur_bus_st = pur.getPur_bus_st();%><%if(pur_bus_st.equals("1")){%>��ü����<%}else if(pur_bus_st.equals("2")){%>�����������<%}else if(pur_bus_st.equals("3")){%>�����̰�<%}else if(pur_bus_st.equals("4")){%>������Ʈ<%}%>
		  
                   </td>		
              </tr>	             	
                <tr>
                    <td width="13%" class='title'>�������</td>
                    <td width="20%">&nbsp;<%=emp1.getEmp_nm()%>
        			  <input type='hidden' name='emp_id' value='<%=emp1.getEmp_id()%>'>			  
                      </td>
                    <td width="10%" class='title'>�����Ҹ�</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(emp1.getCar_comp_id(),"CAR_COM")%>&nbsp;<%=emp1.getCar_off_nm()%></td>
                    <td width="10%" class='title'>����ó</td>
                    <td>&nbsp;<%=emp1.getEmp_m_tel()%></td>
                </tr>
                <tr>
                    <td class='title'>�ҵ汸��</td>
                    <td >&nbsp;<%=emp1.getCust_st()%></td>
                    <td class='title'>�ִ��������</td>
                    <td>&nbsp;<%=emp1.getComm_rt()%>% 
        			</td>
                    <td class='title'>�����������</td>
                    <td>&nbsp;<%=emp1.getComm_r_rt()%>% 
        			</td>
                </tr>
                <tr>
                    <td class='title'>�������</td>
                    <td colspan="3" >&nbsp;<%=emp1.getCh_remark()%></td>
                    <td class='title'>������</td>
                    <td>&nbsp;<%=c_db.getNameById(emp1.getCh_sac_id(),"USER")%></td>
                </tr>
                <tr>
                    <td class='title'>�����</td>
                    <td >&nbsp;<%=emp1.getEmp_bank()%></td>
                    <td class='title'>���¹�ȣ</td>
                    <td>&nbsp;<%=emp1.getEmp_acc_no()%></td>
                    <td class='title'>�����ָ�</td>
                    <td>&nbsp;<%=emp1.getEmp_acc_nm()%></td>
                </tr>		  		  		  
                <tr>
                    <td class='title'>���޼�����</td>
                    <td>&nbsp;<%=Util.parseDecimal(emp1.getCommi())%>��</td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=Util.parseDecimal(emp1.getTot_amt())%>��</td>
                    <td class='title'>��������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(emp1.getSup_dt())%></td>
                </tr>		 
                <!-- 
    		    <%if(emp1.getCommi()>0 && emp1.getSup_dt().equals("")){%>		  		  
                <tr>
                    <td class='title'>�������޿��</td>
                    <td colspan="5">
        			<font color="red">
        			<%int commi_chk = 0;%>
        			<%if(fee.getRent_start_dt().equals("")){ commi_chk++;%>* �����뿩���ð� ���� �ʾҽ��ϴ�.<br><%}%>
        			<%if(car.getGi_st().equals("1") && gins.getGi_dt().equals("")){ commi_chk++;%>* �������谡���� �ϰ���� �ʾҽ��ϴ�.<br><%}%>
        			<%String ext_pay_st = a_db.getPpPaySt(rent_mng_id, rent_l_cd, fee.getRent_st(), "");%>
        			<%if(!ext_pay_st.equals("-") && !ext_pay_st.equals("�Ա�")){ commi_chk++;%>* �ʱⳳ�Ա��� �ϳ����� �ʾҽ��ϴ�.<br><%}%>
        			</font>
        			</td>
                </tr>		
    		    <%}%>  		  		  
                -->
            </table>
        </td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������-����� <%if(user_id.equals("000000") || base.getBus_id().equals(user_id)){%><a href="javascript:update('emp2','')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a><%}%><font color="#CCCCCC"> ( ������ : �������-����� ���� )</font></span></td>
	</tr>	
    <tr id=tr_emp_dlv style="display:<%if(base.getCar_gu().equals("1")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
            	    <td class=line2 style='height:1'></td>
            	</tr>				
                <tr>
                    <td width="13%" class='title'>�����</td>
                    <td width="20%">&nbsp;<%=emp2.getEmp_nm()%>
        			  <input type='hidden' name='emp_id' value='<%=emp2.getEmp_id()%>'>
        			  </td>
                    <td width="10%" class='title'>�����Ҹ�</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(emp2.getCar_comp_id(),"CAR_COM")%>&nbsp;<%=emp2.getCar_off_nm()%></td>
                    <td width="10%" class='title'>����ó</td>
                    <td>&nbsp;<%=emp2.getEmp_m_tel()%></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td><font color="#CCCCCC">�� ������ڰ� ��ϵǾ�� ������ݹ���ó���� ��Ÿ���ϴ�.</font></td>
	</tr>		
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	

//-->
</script>
</body>
</html>
