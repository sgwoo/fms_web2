<%@ page language="java" contentType="text/html;charset=euc-kr"%>
	<tr>
		<td colspan="2"><div align="center">
		<%if(base.getCar_st().equals("3")){	//���� %>
			<span class=style1>�ڵ���  �ü��뿩(����) ��༭</span>
		<%}else{ 	//��Ʈ%>
			<span class=style1>�� �� ��  �� �� �� ��  �� �� ��</span>
		<%} %>
		</div></td>
	</tr>
	<tr>
		<td width=76.5%>&nbsp;<img src=http://fms1.amazoncar.co.kr/acar/images/logo_1.png></td>
		<td width=23.5% class="cnum right">
			<table align="right" width="100%">
				<tr>
					<th class="center" width="45%">������ȣ</th>
					<td class="center" width="55%"><%=cr_bean.getCar_no()%></td>
				</tr>
			</table>
		</td>
	</tr>	
  	<tr>
 		<td colspan="2" class="doc">
			<table class="style9">
		      	<tr>
			 		<th width="13%">����ȣ</th>
			   		<td width="19%">&nbsp;<%=rent_l_cd%></td>
			    	<th width="13%">������</th>
			     	<td width="19%">&nbsp;<%=c_db.getNameById(bus_user_bean.getBr_id(),"BRCH")%></td>
			     	<th width="13%">���������</th>
			   		<td width="23%">&nbsp;<%=bus_user_bean.getUser_nm()%>&nbsp;<%=bus_user_bean.getUser_m_tel()%></td>
		   		</tr>
				<tr>
			    	<td class="center title">�뿩��ǰ ����</td>
			    	<td colspan="4">
		    		<%if(base.getCar_st().equals("3")){	//���� %>
						<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_st().equals("3") && !fee.getRent_way().equals("1"))%>checked<%%>>���� �⺻��(���񼭺� ������)   
		    	    	<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_st().equals("3") && fee.getRent_way().equals("1"))%>checked<%%>>���� �Ϲݽ�(���񼭺� ����)  
					<%}else{ 	//��Ʈ%>
			    		<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_st().equals("1") && !fee.getRent_way().equals("1"))%>checked<%%>>��ⷻƮ �⺻��(���񼭺� ������) 
						<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_st().equals("1") && fee.getRent_way().equals("1"))%>checked<%%>>��ⷻƮ �Ϲݽ�(���񼭺� ����)
					<%} %>
		    	    </td>
			     	<td><input type="checkbox" name="checkbox" value="checkbox" <%if(rent_st.equals("1") && base.getCar_gu().equals("1"))%>checked<%%>>���� 
			     	    <input type="checkbox" name="checkbox" value="checkbox" <%if(rent_st.equals("1") && base.getCar_gu().equals("0"))%>checked<%%>>������
			     	    <input type="checkbox" name="checkbox" value="checkbox" <%if(!rent_st.equals("1"))%>checked<%%>>����</td>
				</tr>
    		</table>
		</td>
	</tr>
	<tr>
    	<td colspan="2"><span class=style2>1. ������</span></td>
	</tr>
	<tr>
    	<td colspan="2" class="doc">
      		<table>
		        <tr>
		        	<th width="14%">������</th>
		        	<td colspan="6"><input type="checkbox" name="checkbox" value="checkbox" <%if(client.getClient_st().equals("1"))%>checked<%%>>���� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		        	    <input type="checkbox" name="checkbox" value="checkbox" <%if(!client.getClient_st().equals("1")&&!client.getClient_st().equals("2"))%>checked<%%>>���λ���� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		        	    <input type="checkbox" name="checkbox" value="checkbox" <%if(client.getClient_st().equals("2"))%>checked<%%>>����</td>
		        </tr>
		        <tr>
		        	<th>�� ȣ</th>
		        	<td colspan="2">&nbsp;<%=client.getFirm_nm()%></td>
		        	<th>����ڹ�ȣ</th>
		        	<td colspan="3">&nbsp;<%if(!client.getClient_st().equals("2")){%><%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%><%}%></td>
		        </tr>
		        <tr>
		        	<th>����(��ǥ��)</th>
		        	<td width="24%">&nbsp;<%if(!client.getClient_st().equals("2")){%><%=client.getClient_nm()%><%}%></td>
		        	<th width="17%">����(�ֹ�)��Ϲ�ȣ</th>
		        	<td width="15%">&nbsp;<%if(client.getClient_st().equals("1")){%><%=client.getSsn1()%>-<%=client.getSsn2()%><%}else{%><%if(AddUtil.parseInt(AddUtil.getDate(4)) > 20140806){%><%=client.getSsn1()%><%}else{%><%=client.getSsn1()%>-<%=client.getSsn2()%><%}%><%}%></td>
		        	<th width="4%" rowspan="2">��<br>��<br>��</th>
		        	<th width="10%" class="center">��ȭ��ȣ</th>
		        	<td width="16%">&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></td>
		        </tr>
		        <tr>
		        	<th>�� ��(����)</th>
		        	<td colspan="3">&nbsp;<%=client.getO_addr()%></td>
		        	<th class="center">�ѽ���ȣ</th>
		        	<td>&nbsp;<%=AddUtil.phoneFormat(client.getFax())%></td>
		        </tr>
		        <tr>
		        	<th>���������ּ�</th>
		        	<td colspan="3">&nbsp;<%= base.getP_addr()%>&nbsp;<%=base.getTax_agnt()%></td>
		        	<th colspan="2"><span style="letter-spacing: -1px;">��ǥ���޴�����ȣ</span></th>
		        	<td>&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
		        </tr>		        
		        <tr>
		        	<th>��뺻�����ּ�</th>
		        	<td colspan="3">&nbsp;<%=site.getAddr()%>&nbsp;<%=site.getR_site()%></td>
		        	<th class="center" colspan="2">���������ȣ</th>
		        	<%	CarMgrBean mgr1 = new CarMgrBean();
                	for(int i = 0 ; i < mgr_size ; i++){
   						CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
   						if(mgr.getMgr_st().equals("�����̿���")){
   							mgr1 = mgr;
   						}
					}                       
              %>
		        	<td>&nbsp;<%=base.getLic_no()%></td>
		        </tr>
	    	</table>	
			<table>
		        <tr>
		        	<th width="12%">�� ��</th>
		        	<th width="10%">�ٹ��μ�</th>
		        	<th width="14%">�� ��</th>
		        	<th width="9%">�� ��</th>
		        	<th width="17%">��ȭ��ȣ</th>
		        	<th width="13%">�޴�����ȣ</th>
		        	<th width="26%">E-MAIL</th>
		        </tr>
		        <%
        		  	for(int i = 0 ; i < mgr_size ; i++){
        				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);        		
        				
        				if(mgr.getMgr_st().equals("�����̿���") || mgr.getMgr_st().equals("����������") || mgr.getMgr_st().equals("ȸ�������")){
        		%>
		        <tr>
		        	<th class="center"><%=mgr.getMgr_st()%></th>
		        	<td class="center"><%=mgr.getMgr_dept()%></td>
		        	<td class="center"><%=mgr.getMgr_nm()%></td>
		        	<td class="center"><%=mgr.getMgr_title()%></td>
		        	<td class="center"><%=AddUtil.phoneFormat(mgr.getMgr_tel())%></td>
		        	<td class="center"><%=AddUtil.phoneFormat(mgr.getMgr_m_tel())%></td>
		        	<td class="center"><%=mgr.getMgr_email()%></td>
		        </tr>
		        <%		}
		        	}%>
  			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2"><span class=style2>2. �뿩�̿� �⺻����</span></td>
	</tr>
	<tr>
		<td colspan="2" class="doc">
			<table class="center">
				<tr>
					<th rowspan="2" width="5%">��<br>��<br>��<br>��</th>
					<th width="18%">����</th>
					<th width="40%">���û��</th>
					<th width="15%">����</th>
					<th width="17%">��������<br><span class="fs">-������ �Һ��ڰ���-</span></th>
					<th width="5%">���</th>
				</tr>
				<tr>
					<td>&nbsp;<%=cm_bean.getCar_nm()%>&nbsp;<%=cm_bean.getCar_name()%></td>
					<td>&nbsp;<%=car.getOpt()%></td>
					<td>&nbsp;<%=car.getColo()%> 
						<%if(!car.getIn_col().equals("")){%>
						&nbsp;
					  	(����:<%=car.getIn_col()%>)  
						<%}%>
						<%if(!car.getGarnish_col().equals("")){%>
						&nbsp;
					  	(���Ͻ�:<%=car.getGarnish_col()%>)  
						<%}%>
					</td>
					<td>&nbsp;<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt())%>��					    
					    <%if(!base.getCar_gu().equals("1") || !rent_st.equals("1")){ //����,�縮��%>
					    <br>
					    <%		if(fee_opt_amt>0){%>
					    &nbsp;(<%=AddUtil.parseDecimal(fee_opt_amt)%>��)
					    <%		}else{%>
					    &nbsp;(<%=AddUtil.parseDecimal(fee_etc.getSh_amt())%>��)
					    <%		}%>
					    <%}else{%>
					    <%	if(car.getTax_dc_s_amt() > 0){%>
					    	<br>&nbsp;(���Ҽ� ������)
					    <%	}%>
					    <%	if(cont_etc.getView_car_dc() > 0){%>
					    	<br>(<%=AddUtil.parseDecimal(cont_etc.getView_car_dc())%>��)
					    <%	}%>
					    <%}%>
					</td>
					<td>1��</td>
				</tr>
				<tr>
					<th>�̿�<br>�Ⱓ</th>
					<td colspan="5"><input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getCon_mon().equals("12"))%>checked<%%>>12���� 
					    &nbsp;&nbsp;<input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getCon_mon().equals("24"))%>checked<%%>>24���� 
					    &nbsp;&nbsp;<input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getCon_mon().equals("36"))%>checked<%%>>36���� 
					    &nbsp;&nbsp;<input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getCon_mon().equals("48"))%>checked<%%>>48���� 
					    &nbsp;&nbsp;<input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getCon_mon().equals("12")||fee.getCon_mon().equals("24")||fee.getCon_mon().equals("36")||fee.getCon_mon().equals("48")){%><%}else{%>checked<%}%>>��Ÿ( <%if(fee.getCon_mon().equals("12")||fee.getCon_mon().equals("24")||fee.getCon_mon().equals("36")||fee.getCon_mon().equals("48")){%>&nbsp;&nbsp;&nbsp;<%}else{%><%=fee.getCon_mon()%><%}%>)����<br>
					    <%if(fee.getRent_start_dt().equals("")){%>
					    20 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�Ϻ��� &nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp; 20 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ϱ���
					    <%}else{%>
					    <%=AddUtil.getDate3(fee.getRent_start_dt())%>���� ~ <%=AddUtil.getDate3(fee.getRent_end_dt())%>����
					    <%}%>
					</td>
				</tr>
			</table>
			<table class="center">
				<tr>
					<th rowspan="6" width="5%">�������</th>
					<th width="20%">�����ڹ���</th>
					<th width="13%">�����ڿ���</th>
					<th colspan="3">���谡�Աݾ� (�����ѵ�)</th>
				</tr>
				<tr>
					<td rowspan="4" class="left"><input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getCom_emp_yn().equals("Y")){%> checked <%}%>>������� ������<br><span class="fs">(������ �������� Ư�� ����)</span><br><br>
					<input type="checkbox" name="checkbox" value="checkbox" <%if(!cont_etc.getCom_emp_yn().equals("Y")){%> checked <%}%>>�����<br> &nbsp;&nbsp;&nbsp;&nbsp; ������� ������/����<br> &nbsp;&nbsp;&nbsp;&nbsp; ����� �������� ����</td>
					<td rowspan="4" class="left">
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getDriving_age().equals("0")){%> checked <%}%>>��26�� �̻�<br>
				    <%if(base.getCar_st().equals("3")){ //���� %>
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getDriving_age().equals("3")){%> checked <%}%>>��24�� �̻�<br>
				    <%} %>
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getDriving_age().equals("1")){%> checked <%}%>>��21�� �̻�</td>
					<td width="11%">�� �� �� ��</td>
					<td width="26%">����(���ι�� ��,��)</td>
					<td rowspan="4" width="25%" class="left style8">
						�� �ڱ��������� ��å��(�ڱ�δ��)<br>
						<table border="1" style="width: 90%; margin-left: 9px;">
							<tr>
								<td class="center" width="30%">���Ǵ�</td>
								<td width="70%">
									<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_ja()==300000){%> checked <%}%>> 30���� <br> 
					    			<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_ja() > 300000 || base.getCar_ja() < 300000){%> checked <%}%>> ��Ÿ(<%if(base.getCar_ja() > 300000 || base.getCar_ja() < 300000){%><%=base.getCar_ja()/10000%><%}else{%>&nbsp;<%}%>)����
								</td>
							</tr>
						</table>
						<span class="fs">(������ ��� �������ظ�å������ �ǰ� ����-������ ���պ��� ���� ����� ����� ����)</span>
					</td>
				</tr>
				<tr>
					<td>�� �� �� ��</td>
					<td class="left"><!--<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getGcp_kd().equals("1")){%> checked <%}%>>5õ����-->
						<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getGcp_kd().equals("2")){%> checked <%}%>>1���
						<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getGcp_kd().equals("4")){%> checked <%}%>>2���
						<input type="checkbox" name="checkbox" value="checkbox" <%if(!base.getGcp_kd().equals("2")&&!base.getGcp_kd().equals("4")){%> checked <%}%>>��Ÿ
						(<%if(base.getGcp_kd().equals("1")){%>5õ��<%}else if(base.getGcp_kd().equals("8")){%>3��<%}else if(base.getGcp_kd().equals("3")){%>5��<%}%>)��
					</td>
				</tr>
				<tr>
					<td>�ڱ��ü���</td>
					<td class="left"><!--<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getBacdt_kd().equals("1")){%> checked <%}%>>5õ����-->
						<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getBacdt_kd().equals("2")){%> checked <%}%>>1���
					</td>
				</tr>		
				<tr> 
					<td>������������</td>
					<td class="left">
						<input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getCanoisr_yn().equals("Y")){%> checked <%}%>>���� <span class="fs">(�Ǻ����� 1�δ� �ְ�2���)</span>
						<input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getCanoisr_yn().equals("N")){%> checked <%}%>>�̰���						
					</td>
				</tr>	
				<tr>
					<td colspan="5" class="left">* ���⼭ �����̶� �θ�, �����, ������� �θ�, �ڳ�, �����, ������ ���մϴ�. (�������ڸŴ� ���Ե��� �ʽ��ϴ�)<br>
					<%-- <%if(base.getCar_st().equals("3")){	//���� %>
						* ����⵿ : ����Ÿ�ڵ������� 1588-6688
					<%}else{ 	//��Ʈ%> --%>
						* ����⵿ : 1588-6688, 1670-5494
					<%-- <%} %> --%>
					</td>
				</tr>
			</table>
			<table class="center" style="font-size: 10px;">
				<tr>
					<td width="13%" rowspan="4">�������� ����<br>��������<br>(üũ�� ��ĭ�� ���񽺰� �����˴ϴ�)</td>
					<td width="18%">���뼭��</td>
					<td colspan="3">
						<%-- <input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getPro_yn().equals("Y")){%>checked<%}%>>������ �߻��� ���ó�� ���� ����
						<input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getAc_dae_yn().equals("Y")){%>checked<%}%>>����������(��, ���ػ��ô� �������) --%>
						* ������ �߻��� ���ó�� ���� ����
						* ����������(��, ���ػ��ô� �������)[�������� ����]
					</td>
				</tr>	
				<tr>
					<td colspan="2" width="43%">
						<input type="checkbox" name="checkbox" value="checkbox" <%if(!fee.getRent_way().equals("1")){%>checked<%}%>>�⺻��(���񼭺� ������ ��ǰ)
					</td>
					<td colspan="2" width="42%">
						<input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getRent_way().equals("1")){%>checked<%}%>>�Ϲݽ�(���񼭺� ���� ��ǰ)
					</td>
				</tr>
				<tr>
					<td colspan="2" class="left">
						&nbsp;* �Ƹ����ɾ� ����<br>
						&nbsp;&nbsp;- ���� ���� ���� ���� ��� ���� ��� ����<br>
						&nbsp;&nbsp;- �뿩 ���� 2���� �̳� ���� ������� ���� (�׽������� ����)<br>
						&nbsp;&nbsp;&nbsp; (24�ð� �̻� ������� �԰��)<br>
						&nbsp;&nbsp;- �뿩 ���� 2���� ���� ���� ������ ���� ������� ����<br>
						&nbsp;&nbsp;&nbsp; (�ܱ� �뿩����� 15~30% ����, Ź�۷� ����<br>
					</td>
					<td colspan="2" class="left">
						&nbsp;* ��ü�� ���񼭺�<br>
						&nbsp;&nbsp;- ���� ��������ǰ/�Ҹ�ǰ ����, ��ȯ, ����<br>
						&nbsp;&nbsp;- ������ ���� ��޼��� ����<br>
						&nbsp;&nbsp;�� ���� �����ü�� ���� �԰��Ͽ� ����<br>
						&nbsp;* �����������<br>
						&nbsp;&nbsp;- 4�ð� �̻� ������� �԰��<br>
					</td>
				</tr>
				<tr>
					<td class="left" colspan="4">						
					<%if(base.getCar_st().equals("3")){	//���� %>
						&nbsp;* ģȯ������ �Ϲ� ������� ��������, �������� �������� ���������ϸ� ���������̳� ȭ�������� �¿� �� RV�� ���������մϴ�.
					<%}else{ 	//��Ʈ%>
						&nbsp;* ģȯ������ �Ϲ� ������� ��������, �������� �������� ���������ϸ�, ���������� �¿� �� RV�� ���������մϴ�.
					<%} %>
						<br>
						&nbsp;* ���߻��� �������� �������� �������� �������� �ʽ��ϴ�.<br>&nbsp;&nbsp; - ���� ���� ���������� �ʿ��� ��쿡�� (��)�Ƹ���ī�� Ȯ�� �� ����ġ ������ �־�� (��)�Ƹ���ī����<br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ������ ���ҵ˴ϴ�.</td>
				</tr>	
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2"><span class=style2>3. �� �� �� ��</span></td>
	</tr>
	<tr>
		<td colspan="2" class="doc">
			<table class="right">
				<tr>
					<th width=10%>����</th>
					<th width=15%>������</th>
					<th width=15%>������</th>
					<th width=15%>���ô뿩��</th>
					<th width=15%>���뿩��</th>
					<th width=15%>���뿩��<br>������ Ƚ��</th>
					<th width=15%>���뿩��<br>������ ��¥</th>
				</tr>
				<tr>
					<th>���ް�</th>
					<td><%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>��</td>
					<td><%=AddUtil.parseDecimal(fee.getPp_s_amt())%>��</td>
					<td><%=AddUtil.parseDecimal(fee.getIfee_s_amt())%>��</td>
					<td><%=AddUtil.parseDecimal(fee.getFee_s_amt())%>��</td>
					<td rowspan="3" class="center"><%=fee.getFee_pay_tm()%>&nbsp;ȸ</td>
					<td rowspan="3" class="center">�ſ� 
					    <%if(fee.getFee_est_day().equals("99")){%> &nbsp;���� 
					    <%}else if(fee.getFee_est_day().equals("98")){%> &nbsp;�뿩������ 
					    <%}else{%>
					    &nbsp;&nbsp;<%=fee.getFee_est_day()%>&nbsp;��
					    <%}%>					
					</td>
				</tr>
				<tr>
					<th>�ΰ���</th>
					<td class="center">-</td>
					<td><%=AddUtil.parseDecimal(fee.getPp_v_amt())%>��</td>
					<td><%=AddUtil.parseDecimal(fee.getIfee_v_amt())%>��</td>
					<td><%=AddUtil.parseDecimal(fee.getFee_v_amt())%>��</td>
				</tr>
				<tr>
					<th>�� ��</th>
					<td><%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>��</td>
					<td><%=AddUtil.parseDecimal(fee.getPp_s_amt()+fee.getPp_v_amt())%>��</td>
					<td><%=AddUtil.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%>��</td>
					<td><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>��</td>
				</tr>
				<tr>
					<th rowspan="2">���</th>
					<td colspan="3" class="center">�ʱ� ���Ա� �հ�: &nbsp;&nbsp;<%=AddUtil.parseDecimal(fee.getGrt_amt_s()+fee.getPp_s_amt()+fee.getPp_v_amt()+fee.getIfee_s_amt()+fee.getIfee_v_amt())%>��</td>
					<td colspan="3" class="right">�� ��� ���뿩��� �ڵ���ü ���(CMS) ���� �ݾ��Դϴ�.<br>�� ������ ȸ�� �������� ��� �������Դϴ�.</td>
				</tr>
				<tr>
					<td colspan="6" class="left">
						&nbsp;�� ������ ���ν� ���ݰ�꼭 ���� ��� : 
						<input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getPp_chk().equals("0")){%>checked<%}%>>�ſ� �յ� ���� 
						<input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getPp_chk().equals("1")){%>checked<%}%>>�Ͻù���
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2" class="fss">&nbsp;&nbsp;&nbsp;* 1. �������� ���Ⱓ ������ ���Բ� ȯ���� �帳�ϴ�.<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2. �������� �̿�Ⱓ���� �ſ� ���� �ݾ׾� �����Ǹ�, ��� ������ ȯ�ҵǴ� ���� �ƴմϴ�.<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3. ���ô뿩��� ������ ( &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;)����ġ �뿩�Ḧ �����ϴ� ���Դϴ�.<br>
			<%//if(base.getCar_gu().equals("1") && fee.getRent_st().equals("1")){%>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4. �ʱ� ���Ա� (������, ������, ���ô뿩��)�� ������� 2���������� (��)�Ƹ���ī�� �ԱݵǾ�� �մϴ�.<br>
			<%//}%>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5. ������ ���� �Ǵ� ������ ���� ��å�� ����� ��� �� ����� ���뿩�� �� ���Կɼǰ����� ����� �� �ֽ��ϴ�.
		</td>
	</tr>
	<tr>
		<td colspan="2" class="right fss">( ����ȣ : <%=rent_l_cd%>, Page 1/2, <%=AddUtil.ChangeDate2(fee.getRent_dt())%> )</td>
	</tr>	