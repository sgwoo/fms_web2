<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*, acar.cont.*,acar.client.*, acar.car_register.*, acar.fee.*, acar.res_search.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
	
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<style>

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

</style>

</head>
<body leftmargin="15" topmargin="1">
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 

	
<%
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String doc_dt 	= request.getParameter("doc_dt")==null?"":request.getParameter("doc_dt");
	String rent_start_dt 	= request.getParameter("rent_start_dt")==null?"":request.getParameter("rent_start_dt");
	String rent_end_dt 	= request.getParameter("rent_end_dt")==null?"":request.getParameter("rent_end_dt");
	String vio_dt 	= request.getParameter("vio_dt")==null?"":request.getParameter("vio_dt");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
		
	double img_width 	= 680;
	double img_height 	= 1009;

	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	String car_deli_dt = cont_etc.getCar_deli_dt();
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	cr_bean = crd.getCarRegBean(base.getCar_mng_id());		
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//�����������
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	//��������
	Hashtable reserv = rs_db.getCarInfo(base.getCar_mng_id());	
	
	//3. �뿩-----------------------------
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size = af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
		
	//�������
	Vector im_cont = af_db.im_rent_cont(rent_mng_id, rent_l_cd, rent_st);
	int im_cont_size = im_cont.size();
%>


<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" class="a4">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
		    <td><center><font size="4" face="�ü�ü">>>
                        �ڵ��� �뿩�̿� <%if(!rent_st.equals("1")){%>����<%}%> ��༭ <<
                        </font></center>
		    </td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>			
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>    
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title>������ȣ</td>
                    <td colspan="3">&nbsp;<input name="car_no" type="text" class="whitetext" value="<%=reserv.get("CAR_NO")%>" size="15"></td>
                </tr>
                <tr>
                    <td class=title>����</td>
                    <td colspan="3">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></td>
                </tr>				
                <tr>
                    <td class=title>���ʵ����</td>
                    <td width="37%">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
                    <td width="12%" class=title>�����ȣ</td>
                    <td width="37%">&nbsp;<%=reserv.get("CAR_NUM")%></td>
                </tr>
                <tr>
                    <td class=title>�������</td>
                    <td >&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("DLV_DT")))%></td>
                    <td  class=title>��ⷮ</td>
                    <td >&nbsp;<%=reserv.get("DPM")%>cc</td>
                </tr>
                <tr>
                    <td class=title>Į��</td>
                    <td >&nbsp;<%=reserv.get("COLO")%></td>
                    <td  class=title>����</td>
                    <td >&nbsp;<%=reserv.get("FUEL_KD")%></td>
                </tr>
            </table>
        </td>
    </tr>   
    <tr><td class=h></td></tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>        
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title>����</td>
                    <td colspan="3">&nbsp;<%if(client.getClient_st().equals("1")) 	out.println("����");
                      	else if(client.getClient_st().equals("2"))  			out.println("����");
                      	else if(client.getClient_st().equals("3")) 			out.println("���λ����(�Ϲݰ���)");
                      	else if(client.getClient_st().equals("4"))			out.println("���λ����(���̰���)");
                      	else if(client.getClient_st().equals("5")) 			out.println("���λ����(�鼼�����)");%></td>
                </tr>
                <%if(!client.getClient_st().equals("2")){%>
                <tr> 
                    <td class=title>��ȣ
        			</td>
                    <td colspan="3">&nbsp;<%=client.getFirm_nm()%></td>
                </tr>
                <%}%>
                <tr> 
                    <td class=title>����</td>
                    <td colspan="3">&nbsp;<%=client.getClient_nm()%></td>
                </tr>
                <tr> 
                    <td class=title>����ڹ�ȣ</td>
                    <td width="37%">&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
                    <td width="13%" class=title><%if(client.getClient_st().equals("1")){%>���ι�ȣ<%}else{%>�ֹι�ȣ<%}%></td>
                    <td width="37%">&nbsp;<%=client.getSsn1()%>
					<%if(client.getClient_st().equals("1")){%>-<%=client.getSsn2()%><%}%></td>
                </tr>
                <tr> 
                    <td class=title>�ּ�</td>
                    <td colspan="3"> 
                        &nbsp;<%if(!client.getO_addr().equals("")){%>
    		              ( 
    		              <%}%>
    		              <%=client.getO_zip()%> 
    		              <%if(!client.getO_addr().equals("")){%>
    		              )&nbsp; 
    		              <%}%>
    		              <%=client.getO_addr()%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>    
    <tr><td class=h></td></tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������(��������)</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <% String car_st = base.getCar_st();%>
    <% String rent_way = ext_fee.getRent_way();%>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>����ȣ</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>�뵵/����</td>
                    <td width=20%>&nbsp;
                    	<%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>������<%}else if(car_st.equals("3")){%>����<%}else if(car_st.equals("4")){%>����Ʈ<%}%>
                    	<%if(car_st.equals("1")||car_st.equals("3")){%>
			                &nbsp;
			                <%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}%>
			                <%}%>
		                </td>
                    <td class=title width=15%>�������������</td>
                    <td width=22%>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>
            </table>
	</td>
    </tr>
    <%	String r_rent_dt = ""; 
    		String r_rent_st = ""; 
    		String r_rent_end_dt = ""; 
    		String r_rent_end_dt2 = ""; 
    		String r_rent_start_dt = ""; 
    		String r_rent_start_dt2 = ""; 
    		String r_im_seq = ""; 
    %>	
    <tr>
	<td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
                <tr>
                    <td width="13%" class=title rowspan="<%=Integer.toString(im_cont_size)+1%>">�������</td>
                    <td width="20%" class=title>�������</td>                   
                    <td width="25%" class=title>�뿩������</td>
                    <td width="25%" class=title>�뿩������</td>
                    <td width="17%" class=title>�����</td>
                </tr>
                <% for(int i = 0 ; i < im_cont_size ; i++){
                     Hashtable ht = (Hashtable)im_cont.elementAt(i); 
                     
                     r_rent_st = String.valueOf(ht.get("RENT_ST"));
                     r_rent_dt = String.valueOf(ht.get("RENT_DT"));
                     r_rent_end_dt = String.valueOf(ht.get("RENT_END_DT"));
                     r_rent_start_dt = String.valueOf(ht.get("RENT_START_DT"));
                     
                     	if(car_deli_dt.equals("")){
												if(cont_etc.getRent_suc_dt().equals("")){
													car_deli_dt = r_rent_start_dt;
												}else{
													car_deli_dt = cont_etc.getRent_suc_dt();
												}
											}
											
											if(AddUtil.parseInt(AddUtil.replace(r_rent_start_dt,"-","")) < AddUtil.parseInt(AddUtil.replace(car_deli_dt,"-","")) ){
												r_rent_start_dt = car_deli_dt;
												if(!cont_etc.getRent_suc_dt().equals("")){
													r_rent_dt = cont_etc.getRent_suc_dt();
												}
											}
											
											if(i==0){
												r_rent_start_dt2 = r_rent_start_dt;
											}
											if((i+1)==im_cont_size){
												r_rent_end_dt2 = r_rent_end_dt;
											}
											
                %>
                <tr>
                    <td align="center"><%=AddUtil.ChangeDate2(r_rent_dt)%></td>
                    <td align="center"><input type='text' name='rent_start_dt' size='11' value='<%=AddUtil.ChangeDate2(r_rent_start_dt)%>' class='whitetext'></td>
                    <td align="center"><input type='text' name='rent_end_dt'   size='11' value='<%=AddUtil.ChangeDate2(r_rent_end_dt)%>' class='whitetext'></td>
                    <td align="center"><%if(ht.get("RENT_ST").equals("1")){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById((String)ht.get("EXT_AGNT"),"USER")%><%}%></td>
                </tr>
		<%}%>
            </table>
	</td>
    </tr>	
    <tr><td class=h></td></tr>
    <%
    	//���ǿ���
			Vector imvt = af_db.getFeeImList(rent_mng_id, rent_l_cd, r_rent_st);
			int imvt_size = imvt.size();
    %>    
    <%if(imvt_size>0){%>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ǿ���</span></td>	
    </tr>	  	
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
	        <tr>
		    <td class="title" width="">����</td>
		    <td class="title" width="">����ȸ��</td>
		    <td class="title" width="">����뿩�Ⱓ</td>
		</tr>
		<%for(int i = 0 ; i < imvt_size ; i++){
				Hashtable imh = (Hashtable)imvt.elementAt(i);
				r_rent_end_dt = String.valueOf(imh.get("RENT_END_DT"));
				r_im_seq      = String.valueOf(imh.get("IM_SEQ"));
				r_rent_end_dt2 = r_rent_end_dt;
		%>	
		<tr>
		    <td align="center"><%=i+1%></td>
		    <td align="center">&nbsp;<input type='text' size='3' name='add_tm' value='<%=imh.get("IM_SEQ")%>' maxlength='2' class='whitetext'>ȸ</td>
		    <td align="center">&nbsp;<input type='text' name='rent_start_dt' value='<%=AddUtil.ChangeDate2((String)imh.get("RENT_START_DT"))%>' size='15' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
		        ~&nbsp;&nbsp;&nbsp;&nbsp;
			<input type='text' name='rent_end_dt' value='<%=AddUtil.ChangeDate2((String)imh.get("RENT_END_DT"))%>' size='15' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
		    </td>
		</tr>
		<%}%>
		<%if(cr_bean.getPrepare().equals("9") && AddUtil.parseInt(AddUtil.replace(r_rent_end_dt,"-","")) < AddUtil.parseInt(AddUtil.replace(doc_dt,"-",""))){
				r_rent_end_dt2 = c_db.addMonth(doc_dt, 1);
		%>
		<tr>
		    <td align="center"><%=imvt_size%></td>
		    <td align="center">&nbsp;<input type='text' size='3' name='add_tm' value='<%=AddUtil.parseInt(r_im_seq)+1%>' maxlength='2' class='whitetext'>ȸ</td>
		    <td align="center">&nbsp;<input type='text' name='rent_start_dt' value='<%=AddUtil.ChangeDate2(c_db.addDay(r_rent_end_dt, 1))%>' size='15' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
			~&nbsp;&nbsp;&nbsp;&nbsp;
			<input type='text' name='rent_end_dt' value='<%=AddUtil.ChangeDate2(r_rent_end_dt2)%>' size='15' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
		    </td>
		</tr>	
		<%}else if(AddUtil.parseInt(AddUtil.replace(r_rent_end_dt,"-","")) < AddUtil.parseInt(AddUtil.replace(rent_end_dt,"-",""))){
				r_rent_end_dt2 = rent_end_dt;	
		%>
		<tr>
		    <td align="center"><%=imvt_size%></td>
		    <td align="center">&nbsp;<input type='text' size='3' name='add_tm' value='<%=AddUtil.parseInt(r_im_seq)+1%>' maxlength='2' class='whitetext'>ȸ</td>
		    <td align="center">&nbsp;<input type='text' name='rent_start_dt' value='<%=AddUtil.ChangeDate2(c_db.addDay(r_rent_end_dt, 1))%>' size='15' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
			~&nbsp;&nbsp;&nbsp;&nbsp;
			<input type='text' name='rent_end_dt' value='<%=AddUtil.ChangeDate2(r_rent_end_dt2)%>' size='15' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
		    </td>
		</tr>	
    <%}%>	
	</table>
	</td>
    </tr>
    <%}else{%>	
        <%if((cr_bean.getPrepare().equals("9")||cr_bean.getPrepare().equals("2")||cr_bean.getPrepare().equals("6")) && AddUtil.parseInt(AddUtil.replace(r_rent_end_dt,"-","")) < AddUtil.parseInt(AddUtil.replace(doc_dt,"-","")) ){
        	r_rent_end_dt2 = c_db.addMonth(doc_dt, 1);	
        %>
   <tr>
       <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ǿ���</span></td>	
    </tr>	  	
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
		<tr>
		    <td class="title" width="">����</td>
		    <td class="title" width="">����ȸ��</td>
		    <td class="title" width="">����뿩�Ⱓ</td>
		</tr>
		<tr>
		    <td align="center">1</td>
		    <td align="center">&nbsp;<input type='text' size='3' name='add_tm' value='1' maxlength='2' class='whitetext'>ȸ</td>
		    <td align="center">&nbsp;<input type='text' name='rent_start_dt'  value='<%=AddUtil.ChangeDate2(c_db.addDay(r_rent_end_dt, 1))%>'
		    size='15' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
			~&nbsp;&nbsp;&nbsp;&nbsp;
			<input type='text' name='rent_end_dt' value='<%=AddUtil.ChangeDate2(r_rent_end_dt2)%>'
			size='15' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
		    </td>
		</tr>	
	    </table>
	</td>
    </tr>		
        <%}else if(AddUtil.parseInt(AddUtil.replace(r_rent_end_dt,"-","")) < AddUtil.parseInt(AddUtil.replace(rent_end_dt,"-","")) ){
        		r_rent_end_dt2 = rent_end_dt;	
        	%>
   <tr>
       <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ǿ���</span></td>	
    </tr>	  	
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
		<tr>
		    <td class="title" width="">����</td>
		    <td class="title" width="">����ȸ��</td>
		    <td class="title" width="">����뿩�Ⱓ</td>
		</tr>
		<tr>
		    <td align="center">1</td>
		    <td align="center">&nbsp;<input type='text' size='3' name='add_tm' value='1' maxlength='2' class='whitetext'>ȸ</td>
		    <td align="center">&nbsp;<input type='text' name='rent_start_dt'  value='<%=AddUtil.ChangeDate2(c_db.addDay(r_rent_end_dt, 1))%>'
		    size='15' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
			~&nbsp;&nbsp;&nbsp;&nbsp;
			<input type='text' name='rent_end_dt' value='<%=AddUtil.ChangeDate2(r_rent_end_dt2)%>'
			size='15' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
		    </td>
		</tr>	
	    </table>
	</td>
    </tr>		    
        <%}%>    	
        
         <%if( cr_bean.getCar_no().equals(taecha.getCar_no()) ){
         
         		r_rent_start_dt2 = cont_etc.getCar_deli_dt();
         %>
   <tr>
       <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����Ī����</span></td>	
    </tr>	  	
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
		<tr>
		    <td class="title" width="">����</td>
		    <td class="title" width="">�����Ⱓ</td>
		</tr>
		<tr>
		    <td align="center">1</td>
		    <td align="center">&nbsp;<input type='text' name='rent_start_dt' value='<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_dt())%>'
		   size='15' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
			~&nbsp;&nbsp;&nbsp;&nbsp;
			<input type='text' name='rent_end_dt' value='<%=AddUtil.ChangeDate2(c_db.addDay(r_rent_start_dt,-1))%>'
			size='15' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
		    </td>
		</tr>	
	    </table>
	</td>
    </tr>		
        <%}%>    	
        
        
    <%}%>
    <tr>
	<td height=15></td>
    </tr>
    <tr>
    	<td>&nbsp;&nbsp;&nbsp;&nbsp;�� ������ <%=reserv.get("CAR_NO")%> <b><%=reserv.get("CAR_NM")%></b> ������ 
	    ����� �뿩�Ⱓ �� ���� ���� �Ⱓ�� �����Ͽ� 	    
	    <input type='text' name='rent_start_dt2' value='<%=AddUtil.ChangeDate2(r_rent_start_dt2)%>' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'> ~ 
	    <input type='text' name='rent_end_dt2' value='<%=AddUtil.ChangeDate2(r_rent_end_dt2)%>' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'> ����
    	    ���� �Ͽ����� ������.
    	</td>
    </tr>
	<tr>
		<td align=right><img src=/acar/images/pay_h_ceo.gif style="width: 520px;"></td>
	</tr>        	
</table>

</form>
</body>
</html>

