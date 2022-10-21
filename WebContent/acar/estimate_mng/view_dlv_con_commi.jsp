<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.car_mst.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	AddCarMstDatabase 	a_cmb 	= AddCarMstDatabase.getInstance();
	EstiDatabase 		e_db 	= EstiDatabase.getInstance();
	
	String rent_dt 	= request.getParameter("rent_dt")	==null?"":AddUtil.replace(request.getParameter("rent_dt"),"-","");	
	String car_id 	= request.getParameter("car_id")	==null?"":request.getParameter("car_id");
	String car_seq 	= request.getParameter("car_seq")	==null?"":request.getParameter("car_seq");
	int car_amt 	= request.getParameter("car_amt")	==null? 0:Util.parseDigit(request.getParameter("car_amt"));
	int opt_amt 	= request.getParameter("opt_amt")	==null? 0:Util.parseDigit(request.getParameter("opt_amt"));
	int col_amt 	= request.getParameter("col_amt")	==null? 0:Util.parseDigit(request.getParameter("col_amt"));	
	int o_1 	= request.getParameter("o_1")		==null? 0:Util.parseDigit(request.getParameter("o_1"));
	
	String dir_pur_commi_yn 	= request.getParameter("dir_pur_commi_yn")	==null?"N":request.getParameter("dir_pur_commi_yn");
	
	String from_page = request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String auto_set_amt = request.getParameter("auto_set_amt")	==null?"":request.getParameter("auto_set_amt");
	
	String badcust_chk_from = request.getParameter("badcust_chk_from")	==null?"":request.getParameter("badcust_chk_from");
	
	String client_st 	= request.getParameter("client_st")	==null?"":request.getParameter("client_st");
	String dir_pur_yn 	= request.getParameter("dir_pur_yn")	==null?"":request.getParameter("dir_pur_yn");
	
	//������������ ����
	String doc_type 		= request.getParameter("doc_type")	==null?"":request.getParameter("doc_type");
	
	if(client_st.equals("")){
		client_st = doc_type;
	}
	
	if(rent_dt.equals("")) rent_dt 		= AddUtil.getDate(4);
	
	String jg_b_dt = "";
	
	
	//CAR_NM : ��������
	cm_bean = a_cmb.getCarNmCase(car_id, car_seq);

	//�������� �������� �������
	jg_b_dt = e_db.getVar_b_dt(cm_bean.getJg_code(), "jg", rent_dt);
			
	//�߰����ܰ�����
	EstiJgVarBean ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), jg_b_dt);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript">
<!--

	var dlv_con_commi = 0;
	
	function getShCarAmt(){	
		var fm = document.form1;
		var i =0;
		
		//�������
		fm.nm[i].value = "�������";					fm.value[i].value = '<%=rent_dt%>';		i++;
		
		//������������
		fm.nm[i].value = "������������";				fm.value[i].value = '<%=jg_b_dt%>';		i++;

		//��������
		fm.nm[i].value = "��������";					fm.value[i].value = '<%=ej_bean.getSh_code()%>';		i++;

		//����������
		fm.nm[i].value = "����������";					fm.value[i].value = '<%=ej_bean.getJg_w()%>';		i++;

		//��������
		var o_1 = <%=car_amt+opt_amt+col_amt%>;
		if(<%=jg_b_dt%> >= 20160504){ //������,������,������� �ƴϸ� ���ıݾ� -> 20161114 �Ｚ, �ֿ�, ������ �ڵ��� ����������� ��쿡�� �Һ��ڰ�-DC ���� -> 20200428 ������'0004'�� DC���ݾ� 
			if(('<%=cm_bean.getCar_comp_id()%>' == '0003' || '<%=cm_bean.getCar_comp_id()%>' == '0005') && <%=o_1%> > 0 ){     
				o_1 = <%=o_1%>;
			}
		}
		fm.nm[i].value = "��������";					fm.value[i].value = parseDecimal(o_1);		i++;
		
		//������ Ư�Ҽ���
		var o_2 = <%=ej_bean.getJg_3()%>;
		if(<%=jg_b_dt%> < 20190419 && '<%=ej_bean.getJg_2()%>' == '1'){
			o_2 = 0;
		}
		if(<%=jg_b_dt%> < 20190502 && '<%=cm_bean.getDuty_free_opt()%>' =='1'){ //20190502
			o_2 = 0;
		}
		if('<%=ej_bean.getJg_2()%>' == '1' && '<%=cm_bean.getDuty_free_opt()%>' =='1'){ //20210423
			o_2 = 0;
		}
		fm.nm[i].value = "�����Һ�";					fm.value[i].value = o_2;			i++;
		
		
		if(<%=jg_b_dt%> >= 20131104){
				
			//�븮����������
			var o_5 = <%=ej_bean.getJg_e_d()%>;
			fm.nm[i].value = "�븮����������";				fm.value[i].value = o_5;			i++;
			
			//���������������
			var o_7 = <%=ej_bean.getJg_x()%>;

			////// ��������� ��� (Ư�� ������) /////--------------------------------------------------------------
			
			if(<%=jg_b_dt%> >= 20220801){
				// Ư�����(�����̰�����) üũ�� 0.55
				if ('<%=dir_pur_commi_yn%>' == 'Y') {
					o_7 = 0.55;
				}
			}else{
				//������   �������������(�⺻)
				if ('<%=cm_bean.getCar_comp_id()%>' == '0001') {
					//���ΰ� 
					if ('<%=client_st%>' == '1') {
						// Ư�����(�����̰�����) üũ�� 0.6 ����_201906 -> 20220110 0.55
						if ('<%=dir_pur_commi_yn%>' == 'Y') {
							o_7 = 0.6;
							if(<%=jg_b_dt%> >= 20220110){
								o_7 = 0.55;
							}
						}
						// ��ü���븮����� ���ý� 0.7 ����_201911
						if ('<%=dir_pur_commi_yn%>' == '2') {
							o_7 = 0.7;
						}
					//���ΰ�,���λ���ڰ�	20200121
					}else if ('<%=client_st%>' == '2' || '<%=client_st%>' == '3' || '<%=client_st%>' == '4' || '<%=client_st%>' == '5'){
						// ��Ÿ��ü���
						if ('<%=dir_pur_yn%>' != 'Y') {
							o_7 = 0.7;
						}					
					}
				}
			}
			fm.nm[i].value = "���������������";				fm.value[i].value = o_7;			i++;			
				
			//����������� (�Ҽ������ڸ��ݿø�)
			var o_8 = Math.round(o_5/(1+o_2)*o_7/1.1*10000)/10000;
			//��Ʈ�� (1+�����Һ���) ������ �ʴ´�.
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>'=='5033111'){
				o_8 = Math.round(o_5*o_7/1.1*10000)/10000;
			}
			//�������� 1%
			if(<%=ej_bean.getJg_w()%> == 1){
				o_8 = 1/100;
				if(<%=jg_b_dt%> >= 20161107){
					o_8 = 2/100;
				}
			}

			fm.nm[i].value = "�����������";				fm.value[i].value = o_8;			i++;
							
			//���������
			var o_9 = th_round(o_1*o_8);
			dlv_con_commi = o_9;
			fm.nm[i].value = "���������";				fm.value[i].value = parseDecimal(o_9);		i++;
			
			
			////// ��������� ��� (�븮�� ������) /////--------------------------------------------------------------
			
			<%if(cm_bean.getCar_comp_id().equals("0001") && (badcust_chk_from.equals("esti_mng_atype_i.jsp") || from_page.equals("esti_mng_atype_u.jsp"))){%>
				
				//���������������
				o_7 = 0.7;
				
				fm.nm2[0].value = "���������������";				fm.value2[0].value = o_7;			i++;			
					
				//����������� (�Ҽ������ڸ��ݿø�)
				o_8 = Math.round(o_5/(1+o_2)*o_7/1.1*10000)/10000;
				//��Ʈ�� (1+�����Һ���) ������ �ʴ´�.
				if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>'=='5033111'){
					o_8 = Math.round(o_5*o_7/1.1*10000)/10000;
				}
				//�������� 1%
				if(<%=ej_bean.getJg_w()%> == 1){
					o_8 = 2/100;					
				}
				fm.nm2[1].value = "�����������";				fm.value2[1].value = o_8;			i++;
							
				//���������
				o_9 = th_round(o_1*o_8);
				dlv_con_commi = o_9;
				fm.nm2[2].value = "���������";				fm.value2[2].value = parseDecimal(o_9);		i++;
			<%}%>
			
		
		}else{
						
			//�����Һ񼼸鼼 ����
			var o_3 = o_1/(1+o_2);		
			fm.nm[i].value = "�����Һ񼼸鼼 ����";				fm.value[i].value = parseDecimal(o_3);		i++;
		
			//�����Һ񼼸鼼 ��������
			var o_4 = o_3/1.1;
			fm.nm[i].value = "�����Һ񼼸鼼 ��������";			fm.value[i].value = parseDecimal(o_4);		i++;
		
			//�븮����������
			var o_5 = <%=ej_bean.getJg_e_d()%>;
			fm.nm[i].value = "�븮����������";				fm.value[i].value = o_5;			i++;
		
			//�븮��������
			var o_6 = o_4*o_5;
			fm.nm[i].value = "�븮��������";				fm.value[i].value = parseDecimal(o_6);		i++;
		
			//���������������
			var o_7 = <%=ej_bean.getJg_x()%>;
			/* �����ڵ����̸� Ư�����(�����̰�����) üũ�� 0.6 ����_201906 */
			if ('<%=dir_pur_commi_yn%>' == 'Y') {
				if ('<%=cm_bean.getCar_comp_id()%>' == '0001') {
					o_7 = 0.6;
				}
			}
			fm.nm[i].value = "���������������";				fm.value[i].value = o_7;			i++;
		
			//���������
			var o_8 = th_round(o_6*o_7);
			dlv_con_commi = o_8;
			fm.nm[i].value = "���������(�븮��������*���������������)";				fm.value[i].value = parseDecimal(o_8);		i++;
		
		}

				
	}
	
	function save(){
		var ofm = opener.document.form1;
		var fm = document.form1;
		ofm.dlv_con_commi.value = parseDecimal(dlv_con_commi);
		
		<%if(auto_set_amt.equals("Y")){%>
			opener.set_amt();
		<%}%>	
		
		self.close();
	}
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������� ��� <%if(cm_bean.getCar_comp_id().equals("0001") && (badcust_chk_from.equals("esti_mng_atype_i.jsp") || from_page.equals("esti_mng_atype_u.jsp"))){%>(Ư�� ������)<%}%></span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td width="10%" class=title>����</td>
                    <td width="50%" class=title>�׸�</td>
                    <td width="40%" class=title>��</td>
                </tr>
        		  <%for(int i=0; i<11; i++){%>
                <tr>
        	    <td align="center"><%=i+1%></td>                    
                    <td align="center"><input type="text" name="nm" value="" size="30" class=whitetext></td>
                    <td align="center"><input type="text" name="value" value="" size="12" class=whitenum></td>          
                </tr>
        	    <%}%>
            </table>
        </td>
    </tr>
    <tr>
        <td>* ����,������� ������ ������ ������ DC�� �������� ������</td>
    </tr>
    <%if(ej_bean.getJg_x()==0){%>
    <!--
    <tr>
        <td>* ��������� = �븮��������*���������������</td>
    </tr>          
    -->
    <%}%>
    <!-- ������������ --->
    <%if(cm_bean.getCar_comp_id().equals("0001") && (badcust_chk_from.equals("esti_mng_atype_i.jsp") || from_page.equals("esti_mng_atype_u.jsp"))){%>
    <tr>
        <td>&nbsp;</td>
    </tr>      
	<tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������� ��� (�븮�� ������)</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td width="10%" class=title>����</td>
                    <td width="50%" class=title>�׸�</td>
                    <td width="40%" class=title>��</td>
                </tr>
        		  <%for(int i=0; i<3; i++){%>
                <tr>
        	    <td align="center"><%=i+1%></td>                    
                    <td align="center"><input type="text" name="nm2" value="" size="30" class=whitetext></td>
                    <td align="center"><input type="text" name="value2" value="" size="12" class=whitenum></td>          
                </tr>
        	    <%}%>
            </table>
        </td>
    </tr>    
    <%}%>
    <tr> 
        <td align="right"> 
         	<%if(auto_set_amt.equals("Y")){%>
         		<a href="javascript:save();"><img src=/acar/images/center/button_conf.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
         	<%}%>
        
			<a href="javascript:self.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
        </td>
    </tr>  
      	
</table>	
</form>	
<script>
<!--
	getShCarAmt();	
//-->
</script>	
</body>
</html>