<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.*, acar.cont.*, acar.car_office.*, card.*, acar.car_mst.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="ej_bean"   class="acar.estimate_mng.EstiJgVarBean"    scope="page"/>
<%@ include file="/acar/cookies.jsp" %> 

<%

	CommonDataBase c_db = CommonDataBase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, "01", "01", "09");

	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 		= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");	
	String msg_st 		= request.getParameter("msg_st")==null?"":request.getParameter("msg_st");
	
	if(m_id.equals("")){
		m_id = rent_mng_id;
		l_cd = rent_l_cd;
	}
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	
	//����������
	Hashtable est = a_db.getRentEst(m_id, l_cd);
	
	//�������
	ContPurBean pur = a_db.getContPur(m_id, l_cd);
	
	CommiBean emp2 	= a_db.getCommi(m_id, l_cd, "2");
	
	if(pur.getDir_pur_yn().equals("Y") && emp2.getEmp_id().equals("")){
		emp2 	= a_db.getCommi(m_id, l_cd, "1");
	}
	
	//�������
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp2.getEmp_id());
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
		
	//�ܰ�����NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAll("0003");
	int bank_size = banks.length;	
	
	//ī������ ����Ʈ ��ȸ
	Vector card_kinds = CardDb.getCardKinds("", "");
	int ck_size = card_kinds.size();	
	
	//����Ʈ �ӽÿ��ຸ���
	int b_ins_amt = 0;
	if(pur.getOne_self().equals("Y")){
		if(coe_bean.getCar_off_id().equals("00631") || coe_bean.getCar_off_id().equals("00588")){
			//�¿�-�Ϲ�-6������
			if(AddUtil.parseInt(ej_bean.getJg_a()) >= 100 && AddUtil.parseInt(ej_bean.getJg_a()) <= 402){
				b_ins_amt = 2000;
			}
			//�¿�-�Ϲ�-6������-������
			if(AddUtil.parseInt(ej_bean.getJg_a()) >= 901 && AddUtil.parseInt(ej_bean.getJg_a()) <= 904){
				b_ins_amt = 2000;
			}
			//�¿�-���ν�-10������
			if(AddUtil.parseInt(ej_bean.getJg_a()) >= 501 && AddUtil.parseInt(ej_bean.getJg_a()) <= 701){
				b_ins_amt = 2800;
			}
			//ȭ��-��-1������
			if(AddUtil.parseInt(ej_bean.getJg_a()) >= 801 && AddUtil.parseInt(ej_bean.getJg_a()) <= 803){
				b_ins_amt = 3100;
			}
			//ȭ��-��-1��~5������
			if(AddUtil.parseInt(ej_bean.getJg_a()) >= 811 && AddUtil.parseInt(ej_bean.getJg_a()) <= 821){
				b_ins_amt = 2700;
			}
			//����
			if(AddUtil.parseInt(ej_bean.getJg_a()) == 702){
				b_ins_amt = 3400;
			}
			//����-��Ÿ����11�ν�
			if(AddUtil.parseInt(ej_bean.getJg_a()) == 700){
				b_ins_amt = 3400;
			}
		}
	}
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function update(){		
		var fm = document.form1;
		
		<%if(emp2.getCar_off_id().equals("00588") || emp2.getCar_off_id().equals("04514")){ %>
		var now = new Date();//����ð�
		var hour = now.getHours();
		if(fm.trf_st5.value == '3' && hour > 15){
			alert('ī��� ���� ����4�ÿ� �����մϴ�. ����4�� ���Ŀ��� ���� ��û�ϼ���'); return;
		}
		<%}%>

		
		if(fm.trf_st5.value == '' || fm.card_kind5.value == '' || fm.cardno5.value == ''){
			alert('���޼��� �� ������ �Է��Ͻʽÿ�.'); return;
		}
		
		
		
		if(confirm('�����Ͻðڽ��ϱ�?')){
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");
				
			fm.action='reg_trfamt5_a.jsp';		
			fm.target='i_no';
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}
	}
	
	//���¹�ȣ
	function cng_input_bank(value, idx){
		var fm = document.form1;		
		var width = 800;	
		if(value == '1'){
			window.open("/fms2/car_pur/s_bankacc.jsp?go_url=/fms2/car_pur/pur_doc_u.jsp&emp_id=<%=emp2.getEmp_id()%>&car_off_id=<%=emp2.getCar_off_id()%>&value=<%=emp2.getCar_off_nm()%>&idx="+idx, "CARDNO", "left=10, top=10, width="+width+", height=600, scrollbars=yes, status=yes, resizable=yes");	
		}
	}	
	
	//ī���ȣ ��ȸ
	function cng_input_card(value, idx){
		var fm = document.form1;
		
		//������ ������
		if(fm.trf_st5.value == '1') return;
		//����
		if(fm.trf_st5.value == '4') return;
		
		//����,�ĺ�ī��
		var width = 500;
		window.open("s_cardno.jsp?go_url=/fms2/car_pur/pur_doc_u.jsp&value="+value+"&idx="+idx, "CARDNO", "left=10, top=10, width="+width+", height=400, scrollbars=yes, status=yes, resizable=yes");
	}	
	
	function OpenImg(url){
  	var img=new Image();
  	var OpenWindow=window.open('','_blank', 'width=1000, height=760, menubars=no, scrollbars=auto');
  	OpenWindow.document.write("<style>body{margin:0px;}</style><img src='"+url+"' width='990'>");
 }
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post'>
<input type='hidden' name="m_id" value="<%=m_id%>">
<input type='hidden' name="l_cd" value="<%=l_cd%>">
<input type='hidden' name="mode" value="<%=mode%>">
<input type='hidden' name="msg_st" value="<%=msg_st%>">
<input type='hidden' name="firm_nm" value="<%=est.get("FIRM_NM")%>">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>�ӽÿ��ຸ��� ���޹��</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	      
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='14%'>����ȣ</td>
                    <td width='31%'>&nbsp;<%=l_cd%></td>
                    <td class='title' width='14%'>��ȣ</td>
                    <td width='41%'>&nbsp;<%=est.get("FIRM_NM")%></td>
                </tr>
                <tr> 
                    <td class='title'>������ȣ</td>
                    <td>&nbsp;<%=est.get("CAR_NO")%></td>
                    <td class='title'>����</td>
                    <td>
                        <table width=100% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td><%=est.get("CAR_NM")%> <%=est.get("CAR_NAME")%></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp; </td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ӽÿ��ຸ���</span>
	    
	    	<!-- <input type="button" class="button" id="b_tmp_ins_amt" value='�����ػ� ����� ����' onclick="javascript:OpenImg('/acar/images/center/tmp_ins_amts.jpg');"> -->	    
	    	
	    	<!-- ���� ��ü��� (����,�ѽŴ�) -->
	    	<%if(pur.getOne_self().equals("Y")){%>
	    	<%	if(coe_bean.getCar_off_id().equals("00631") || coe_bean.getCar_off_id().equals("00588")){ //20210525 ���� ����,�ѽŴ�� ��ĵ���� �ݾ��Է� �ʼ�%>
	    	<input type="button" class="button" id="b_tmp_ins_amt" value='���� ��ü��� ����� ����' onclick="javascript:OpenImg('/acar/images/center/tmp_ins_amts_202108.jpg');">
	    	<%	} %>
	    	<%} %>
	    	
	    	<%if(ck_acar_id.equals("000029") && b_ins_amt >0){ %>
	    	&nbsp;&nbsp;
	    	* ����Ʈ �ӽÿ��ຸ��� : <%=b_ins_amt %>��
	    	<%} %>
	    		
	    	</td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width="10%" class=title>���޼���</td>
                    <td width="15%" class=title>�ݾ�</td>
                    <td width="15%" class=title>ī������/������</td>
                    <td width="10%" class=title>��������</td>					
                    <td width="18%" class=title>ī��/���¹�ȣ</td>
                    <td width="20%" class=title>����</td>
                    <td width="12%" class=title>��������</td>					
                </tr>
        		<%	String trf_st 		= "";
        		 	int    trf_amt 		= 0;
        		  	String card_kind 	= "";
        		  	String cardno 		= "";
        		  	String trf_cont 	= "";
					String trf_pay_dt 	= "";
					String acc_st 		= "";
					trf_st 		= pur.getTrf_st5	();
       				trf_amt 	= pur.getTrf_amt5	();
       				card_kind 	= pur.getCard_kind5	();
       				cardno 		= pur.getCardno5	();
       				trf_cont 	= pur.getTrf_cont5	();
					trf_pay_dt	= pur.getTrf_pay_dt5();
					acc_st 		= pur.getAcc_st5	();
					//����Ʈ�ݾ� ������ �ݿ�
					if(trf_amt==0 && b_ins_amt >0){
						trf_amt = b_ins_amt;
					}
					
					if(trf_amt > 0 && pur.getTrf_pay_dt5().equals("") && pur.getTrf_st5().equals("")){
						//20220916 �����ѽŴ�븮���� �켱 ī�� ����Ʈ ó��
							if(emp2.getCar_off_id().equals("00588")){
								pur.setTrf_st5("3");
							}else{
								pur.setTrf_st5("1");
							}
					}
					
     		  		%>
                <tr>
                    <td align="center">
        			  <select name="trf_st5" class='default' onChange="javascript:cng_input_bank(this.value, 5)">
                        <option value="">==����==</option>
        				<option value="3" <%if(trf_st.equals("3")) out.println("selected");%>>ī��</option>
        				<option value="1" <%if(trf_st.equals("1")) out.println("selected");%>>����</option>
        			  </select>
        			  </td>
                    <td align="center"><input type='text' size='10' maxlength='15' name='trf_amt5' class='defaultnum' value='<%=AddUtil.parseDecimal(trf_amt)%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center">
        			  <select name="card_kind5" class='default' onChange="javascript:cng_input_card(this.value, 5)">
                  	    <option value=''>����</option>
                  		<%	if(ck_size > 0){
        						for (int i = 0 ; i < ck_size ; i++){
        							Hashtable ht = (Hashtable)card_kinds.elementAt(i);%>
                  		<option value='<%= ht.get("CARD_KIND") %>' <%if(card_kind.equals(String.valueOf(ht.get("CARD_KIND")))) out.println("selected");%>><%= ht.get("CARD_KIND") %></option>
                  		<%		}
        					}%>
        					
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];	%>
                              <option value='<%= bank.getNm()%>' <%if(card_kind.equals(bank.getNm())){%> selected <%}%>><%= bank.getNm()%> </option>
                              <%	}
        					}	%>					
                	  </select>
        			</td>
                    <td align="center">
        			  <select name="acc_st5" class='default'>
                        <option value="">==����==</option>
        				<option value="1" <%if(acc_st.equals("1")) out.println("selected");%>>��������</option>
        				<option value="2" <%if(acc_st.equals("2")) out.println("selected");%>>�������</option>
        			  </select>
        			  </td>					
                    <td align="center">
        			  <input type='text' size='22' maxlength='100' name='cardno5' class='default' value='<%=cardno%>'>
        			</td>
                    <td align="center"><input type='text' size='25' maxlength='100' name='trf_cont5' class='default' value='<%=trf_cont%>'>
					</td>
                    <td align="center">
					  <%if(trf_amt>0 && !trf_pay_dt.equals("")){%>	
        			  <%=trf_pay_dt%>					  
					  <%}else{%>
					  <%	if(msg_st.equals("trf_amt_pay_req") && pur.getTrf_amt_pay_req().equals("")){%>
					  <a href='javascript:cng_input_bank(document.form1.trf_st5.value, 5)' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
					  <%	}%>
					  <%}%>
        			</td>					
                </tr>
            </table>
        </td>
	</tr> 			
	<%if(msg_st.equals("trf_amt_pay_req") && pur.getTrf_amt_pay_req().equals("")){%>
    <tr>
        <td class=h></td>
    </tr>    <tr>
        <td>
	<input type="checkbox" name="trf_amt_send" value="Y" checked> �۱ݿ�û �޽����� �߼��Ѵ�.
		    </td>
    </tr>
	<%}%>	
    <%if(emp2.getCar_off_id().equals("00588") || emp2.getCar_off_id().equals("04514")){ %>
    <tr>
        <td><font color=red>�� ī��� ���� ����4�ÿ� �����մϴ�. ����4�� ���Ŀ��� ���� ��û�ϼ���. </font></td>
    </tr>	
    <%}%>	
    <tr>
        <td align="right">
		        <a id="submitLink" href='javascript:update()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;
		        <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		    </td>
    </tr>
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
