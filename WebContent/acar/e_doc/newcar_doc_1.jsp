<%@ page language="java" contentType="text/html;charset=euc-kr"%>	
	<tr>
		<td colspan="3">
			<div align="center">
				<%if(String.valueOf(ht.get("CAR_ST")).contains("����")){ // ����%>
					<span class=style1>�ڵ���  �ü��뿩(����) ��༭</span>
				<%}else{ 	//��Ʈ%>
					<span class=style1>�� �� ��  �� �� �� ��  �� �� ��</span>
				<%} %>
			</div>
		</td>
	</tr>
	<tr>
		<td width=25%>&nbsp;<img src=http://fms1.amazoncar.co.kr/acar/images/logo_1.png></td>
		<td width=55% class="center">
			<%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){ // �°�%>
				<span class="style8">(���°��)</span>&nbsp;&nbsp;&nbsp;&nbsp;
			<%} %>
		</td>
		<td width=20% class="cnum right">
			<table>
				<tr>
					<th width=45% class="center">������ȣ</th>
					<td width=55% class="center"><%=ht.get("CAR_NO")%></td>
				</tr>
			</table>
		</td>
	</tr>
  	<tr>
 		<td colspan="3" class="doc">
			<table>
		      	<tr>
			 		<th width="13%">����ȣ</th>
			   		<td width="19%">&nbsp;<%=rent_l_cd%></td>
			    	<th width="13%">������</th>
			     	<td width="19%">&nbsp;<%=ht.get("BR_NM")%></td>
			     	<th width="13%">���������</th>
			   		<td width="23%">&nbsp;<%=ht.get("BUS_USER_NM")%>&nbsp;<%=ht.get("BUS_USER_M_TEL")%></td>
		   		</tr>
				<tr>
			    	<td class="center title" style="height:25px;">�뿩��ǰ ����</td>
			    	<td colspan="4">
			    	<%if(String.valueOf(ht.get("CAR_ST")).equals("3")){	//���� %>
			    		<input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("CAR_ST")).equals("����plus �⺻��"))%>checked<%%>>���� �⺻��(���񼭺� ������)   
		    	    	<input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("CAR_ST")).equals("����plus �Ϲݽ�"))%>checked<%%>>���� �Ϲݽ�(���񼭺� ����)  
					<%}else{ 	//��Ʈ%>
			    		<input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("CAR_ST")).equals("��ⷻƮ �⺻��"))%>checked<%%>>��ⷻƮ �⺻��(���񼭺� ������) 
						<input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("CAR_ST")).equals("��ⷻƮ �Ϲݽ�"))%>checked<%%>>��ⷻƮ �Ϲݽ�(���񼭺� ����)
					<%} %>
			    	</td>    
			     	<td>
			     		<input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("CAR_GU")).equals("����"))%>checked<%%>>���� 
			     	    <input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("CAR_GU")).equals("������"))%>checked<%%>>������
			     	    <input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("CAR_GU")).equals("����"))%>checked<%%>>����
			     	</td>
				</tr>
    		</table>
		</td>
	</tr>
	<tr>
    	<td colspan="3"><span class=style2>1. ������</span></td>
	</tr>
	<tr>
    	<td colspan="3" class="doc">
      		<table>
		        <tr>
		        	<th width="14%">������</th>
		        	<td colspan="6">
		        		<input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("CLIENT_ST")).equals("����"))%>checked<%%>>���� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		        	    <input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("CLIENT_ST")).equals("���λ����"))%>checked<%%>>���λ���� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		        	    <input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("CLIENT_ST")).equals("����"))%>checked<%%>>����
		        	</td>
		        </tr>
		        <tr>
		        	<th>�� ȣ</th>
		        	<td colspan="2">&nbsp;<%=ht.get("FIRM_NM")%></td>
		        	<th>����ڹ�ȣ</th>
		        	<td colspan="3">&nbsp;<%if(!String.valueOf(ht.get("CLIENT_ST")).equals("����")){%><%=ht.get("ENP_NO")%><%}%></td>
		        </tr>
		        <tr>
		        	<th>����(��ǥ��)</th>
		        	<td width="24%">&nbsp;<%if(!String.valueOf(ht.get("CLIENT_ST")).equals("����")){%><%=ht.get("CLIENT_NM")%><%}%></td>
		        	<th width="17%">����(�ֹ�)��Ϲ�ȣ</th>
		        	<td width="15%">&nbsp;<%=ht.get("SSN") %></td>
		        	<th width="4%" rowspan="2">��<br>��<br>��</th>
		        	<th width="10%" class="center">��ȭ��ȣ</th>
		        	<td width="16%">&nbsp;<%=AddUtil.phoneFormat(String.valueOf(ht.get("O_TEL")))%></td>
		        </tr>
		        <tr>
		        	<th>�� ��(����)</th>
		        	<td colspan="3">&nbsp;<%=ht.get("O_ADDR")%></td>
		        	<th class="center">�ѽ���ȣ</th>
		        	<td>&nbsp;<%=AddUtil.phoneFormat(String.valueOf(ht.get("FAX")))%></td>
		        </tr>
		        <tr>
		        	<th>���������ּ�</th>
		        	<td colspan="3">&nbsp;<%=ht.get("P_ADDR")%></td>
		        	<th colspan="2"><span style="font-size:10px;">��ǥ���޴�����ȣ</span></th>
		        	<td>&nbsp;<%=AddUtil.phoneFormat(String.valueOf(ht.get("M_TEL")))%></td>
		        </tr>
		        <tr>
		        	<th>��뺻�����ּ�</th>
					<td colspan="3"><%=ht.get("ADDR2") %></td>
		        	<th class="center" colspan="2">���������ȣ</th>
		        	<td>&nbsp;<%=ht.get("LIC_NO")%></td>
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
		        <tr>
		        	<th class="center">�����̿���</th>
		        	<td class="center"><%=ht.get("MGR_DEPT1")%></td>
		        	<td class="center"><%=ht.get("MGR_NM1")%></td>
		        	<td class="center"><%=ht.get("MGR_TITLE1")%></td>
		        	<td class="center"><%=AddUtil.phoneFormat(String.valueOf(ht.get("MGR_TEL1")))%></td>
		        	<td class="center"><%=AddUtil.phoneFormat(String.valueOf(ht.get("MGR_M_TEL1")))%></td>
		        	<td class="center"><%=ht.get("MGR_EMAIL1")%></td>
		        </tr>
		        <tr>
		        	<th class="center">����������</th>
		        	<td class="center"><%=ht.get("MGR_DEPT2")%></td>
		        	<td class="center"><%=ht.get("MGR_NM2")%></td>
		        	<td class="center"><%=ht.get("MGR_TITLE2")%></td>
		        	<td class="center"><%=AddUtil.phoneFormat(String.valueOf(ht.get("MGR_TEL2")))%></td>
		        	<td class="center"><%=AddUtil.phoneFormat(String.valueOf(ht.get("MGR_M_TEL2")))%></td>
		        	<td class="center"><%=ht.get("MGR_EMAIL2")%></td>
		        </tr>
		        <tr>
		        	<th class="center">ȸ�������</th>
		        	<td class="center"><%=ht.get("MGR_DEPT3")%></td>
		        	<td class="center"><%=ht.get("MGR_NM3")%></td>
		        	<td class="center"><%=ht.get("MGR_TITLE3")%></td>
		        	<td class="center"><%=AddUtil.phoneFormat(String.valueOf(ht.get("MGR_TEL3")))%></td>
		        	<td class="center"><%=AddUtil.phoneFormat(String.valueOf(ht.get("MGR_M_TEL3")))%></td>
		        	<td class="center"><%=ht.get("MGR_EMAIL3")%></td>
		        </tr>
  			</table>
		</td>
	</tr>
	<tr>
		<td colspan="3"><span class=style2>2. �뿩�̿� �⺻����</span></td>
	</tr>
	<tr>
		<td colspan="3" class="doc">
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
					<td>&nbsp;<%=ht.get("CAR_NM")%></td>
					<td>&nbsp;<%=ht.get("OPT")%></td>
					<td  style="height:55px;">&nbsp;<%=ht.get("COLO")%> 
						<%if(!String.valueOf(ht.get("IN_COL")).equals("")){%>
						&nbsp;
					  	(����:<%=ht.get("IN_COL")%>)  
						<%}%>
						<%if(!String.valueOf(ht.get("GARNISH_COL")).equals("")){%>
						&nbsp;
					  	(���Ͻ�:<%=ht.get("GARNISH_COL")%>)  
						<%}%>
					</td>
					<td>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_AMT")))%>��					    
					    <br>
						<%if(Integer.parseInt(String.valueOf(ht.get("SH_AMT"))) > 0){ %>
						    &nbsp;(<%=AddUtil.parseDecimal(String.valueOf(ht.get("SH_AMT")))%>��)
						<% }%>
					    <%if( !String.valueOf(ht.get("CAR_AMT_ETC")).equals("")){ %>
					    	<br>&nbsp;<%=ht.get("CAR_AMT_ETC") %>
					    <%}%>
					    <% if(Integer.parseInt(String.valueOf(ht.get("VIEW_CAR_DC"))) > 0){%>
					    	<br>(<%=AddUtil.parseDecimal(String.valueOf(ht.get("VIEW_CAR_DC")))%>��)
					    <% }%>
					</td>
					<td>1��</td>
				</tr>
				<tr>
					<th>�̿�<br>�Ⱓ</th>
					<td colspan="5"><input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("CON_MON")).equals("12"))%>checked<%%>>12���� 
					    &nbsp;&nbsp;<input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("CON_MON")).equals("24"))%>checked<%%>>24���� 
					    &nbsp;&nbsp;<input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("CON_MON")).equals("36"))%>checked<%%>>36���� 
					    &nbsp;&nbsp;<input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("CON_MON")).equals("48"))%>checked<%%>>48���� 
					    &nbsp;&nbsp;<input type="checkbox" name="checkbox" value="checkbox" <%if( !(String.valueOf(ht.get("CON_MON")).equals("12") || String.valueOf(ht.get("CON_MON")).equals("24") || String.valueOf(ht.get("CON_MON")).equals("36") || String.valueOf(ht.get("CON_MON")).equals("48")) ){%>checked<%}%>>
					    ��Ÿ(<%if( !(String.valueOf(ht.get("CON_MON")).equals("12") || String.valueOf(ht.get("CON_MON")).equals("24") || String.valueOf(ht.get("CON_MON")).equals("36") || String.valueOf(ht.get("CON_MON")).equals("48")) ){%><%=ht.get("CON_MON")%><%}else{%>&nbsp;&nbsp;&nbsp;<%}%>)����
					   <br>
					   <%if(String.valueOf(ht.get("RENT_START_DT")).equals("")){%>
					    	20 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�Ϻ��� &nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp; 20 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ϱ���
					    <%}else{%>
					    	<%=AddUtil.getDate3(String.valueOf(ht.get("RENT_START_DT")))%>���� ~ <%=AddUtil.getDate3(String.valueOf(ht.get("RENT_END_DT")))%>����
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
					<td rowspan="4" class="left">
						<input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("COM_EMP_YN")).equals("Y")){%> checked <%}%>>������� ������<br><span class="fs">(������ �������� Ư�� ����)</span><br><br>
						<input type="checkbox" name="checkbox" value="checkbox" <%if(!String.valueOf(ht.get("COM_EMP_YN")).equals("Y")){%> checked <%}%>>�����<br> &nbsp;&nbsp;&nbsp;&nbsp; ������� ������/����<br> &nbsp;&nbsp;&nbsp;&nbsp; ����� �������� ����
					</td>
					<td rowspan="4" class="left">
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("DRIVING_AGE")).equals("��26�� �̻�")){%> checked <%}%>>��26�� �̻�<br>
					<%if(String.valueOf(ht.get("CAR_ST")).contains("����")){ // ����%>
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("DRIVING_AGE")).equals("��24�� �̻�")){%> checked <%}%>>��24�� �̻�<br>
				    <%} %>    
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("DRIVING_AGE")).equals("��21�� �̻�")){%> checked <%}%>>��21�� �̻�</td>
					<td width="11%">�� �� �� ��</td>
					<td width="26%">����(���ι�� ��,��)</td>
					<td rowspan="4" width="25%" class="left style9">
						�� �ڱ��������� ��å��(�ڱ�δ��)<br>
						<table border="1" style="width: 90%; margin-left: 9px;">
							<tr>
								<td class="center" width="30%">���Ǵ�</td>
								<td width="70%">
									<input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("CAR_JA")).equals("300000")){%> checked <%}%>> 30���� <br> 
					    			<input type="checkbox" name="checkbox" value="checkbox" <%if(!String.valueOf(ht.get("CAR_JA")).equals("300000")){%> checked <%}%>> ��Ÿ(<%if(!String.valueOf(ht.get("CAR_JA")).equals("300000")){%><%=Integer.parseInt(String.valueOf(ht.get("CAR_JA")))/10000%><%}else{%>&nbsp;<%}%>)����
								</td>
							</tr>
						</table>
						<span class="fs">(������ ��� �������ظ�å������ �ǰ� ����-������ ���պ��� ���� ����� ����� ����)</span>
					</td>
				</tr>
				<tr>
					<td>�� �� �� ��</td>
					<td>
						<input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("GCP_KD")).equals("1���")){%> checked <%}%>>1���
						<input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("GCP_KD")).equals("2���")){%> checked <%}%>>2���
						<input type="checkbox" name="checkbox" value="checkbox" <%if(!String.valueOf(ht.get("GCP_KD")).equals("1���") && !String.valueOf(ht.get("GCP_KD")).equals("2���") ){%> checked <%}%>>��Ÿ
						(<%if(String.valueOf(ht.get("GCP_KD")).equals("5õ����")){%>5õ��<%}else if(String.valueOf(ht.get("GCP_KD")).equals("3���")){%>3��<%}else if(String.valueOf(ht.get("GCP_KD")).equals("5���")){%>5��<%}%>)��
					</td>
				</tr>
				<tr>
					<td>�ڱ��ü���</td>
					<td>
						<input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("BACDT_KD")).equals("1���")){%> checked <%}%>>1���
					</td>
				</tr>		
				<tr> 
					<td>������������</td>
					<td>
						<input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("CANOISR_YN")).equals("����")){%> checked <%}%>>���� <span class="fs">(�Ǻ����� 1�δ� �ְ�2���)</span>
						<input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("CANOISR_YN")).equals("�̰���")){%> checked <%}%>>�̰���
					</td>
				</tr>		
				<tr>
					<td colspan="5" class="left" style="height:30px;">
					* ���⼭ �����̶� �θ�, �����, ������� �θ�, �ڳ�, �����, ������ ���մϴ�. (�������ڸŴ� ���Ե��� �ʽ��ϴ�)<br>
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
						* ����������(��, ���ػ��ô� �������) [�������� ����]
					</td>
				</tr>	
				<tr>
					<td colspan="2" width="43%">
						<input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("RENT_WAY_1")).equals("Y")){	// �⺻��%>checked<%}%>>�⺻��(���񼭺� ������ ��ǰ)
					</td>
					<td colspan="2" width="42%">
						<input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("RENT_WAY_2")).equals("Y")){	// �Ϲݽ�%>checked<%}%>>�Ϲݽ�(���񼭺� ���� ��ǰ)
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
					<%if(String.valueOf(ht.get("CAR_ST")).contains("����")){ // ����%>
						&nbsp;* ģȯ������ �Ϲ� ������� ��������, �������� �������� ���������ϸ� ���������̳� ȭ�������� �¿� �� RV�� ���������մϴ�.
					<%}else{ 	//��Ʈ%>
						&nbsp;* ģȯ������ �Ϲ� ������� ��������, �������� �������� ���������ϸ�, ���������� �¿� �� RV�� ���������մϴ�.
					<%} %>
						<br>
						&nbsp;* ���߻��� �������� �������� �������� �������� �ʽ��ϴ�.<br>
						&nbsp;&nbsp; - ���� ���� ���������� �ʿ��� ��쿡�� (��)�Ƹ���ī�� Ȯ�� �� ����ġ ������ �־�� (��)�Ƹ���ī����<br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ������ ���ҵ˴ϴ�.</td>
				</tr>	
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="3"><span class=style2>3. �� �� �� ��</span></td>
	</tr>
	<tr>
		<td colspan="3" class="doc">
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
					<td><%=AddUtil.parseDecimal(String.valueOf(ht.get("GRT_AMT_S")))%>��</td>
					<td><%=AddUtil.parseDecimal(String.valueOf(ht.get("PP_S_AMT")))%>��</td>
					<td><%=AddUtil.parseDecimal(String.valueOf(ht.get("IFEE_S_AMT")))%>��</td>
					<td><%=AddUtil.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%>��</td>
					<td rowspan="3" class="center"><%=ht.get("FEE_PAY_TM")%>&nbsp;ȸ</td>
					<td rowspan="3" class="center">�ſ� <%=ht.get("FEE_EST_DAY")%></td>
				</tr>
				<tr>
					<th>�ΰ���</th>
					<td class="center">-</td>
					<td><%=AddUtil.parseDecimal(String.valueOf(ht.get("PP_V_AMT")))%>��</td>
					<td><%=AddUtil.parseDecimal(String.valueOf(ht.get("IFEE_V_AMT")))%>��</td>
					<td><%=AddUtil.parseDecimal(String.valueOf(ht.get("FEE_V_AMT")))%>��</td>
				</tr>
				<tr>
					<th>�� ��</th>
					<td><%=AddUtil.parseDecimal(String.valueOf(ht.get("GRT_AMT_S")))%>��</td>
					<td><%=AddUtil.parseDecimal(String.valueOf(ht.get("PP_AMT")))%>��</td>
					<td><%=AddUtil.parseDecimal(String.valueOf(ht.get("IFEE_AMT")))%>��</td>
					<td><%=AddUtil.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>��</td>
				</tr>
				<tr>
					<th rowspan="2">���</th>
					<td colspan="3" class="center">�ʱ� ���Ա� �հ�: &nbsp;&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht.get("T_PP_AMT")))%>��</td>
					<td colspan="3" class="right">�� ��� ���뿩��� �ڵ���ü ���(CMS) ���� �ݾ��Դϴ�.<br>�� ������ ȸ�� �������� ��� �������Դϴ�.</td>
				</tr>
				<tr>
					<td colspan="6" class="left">
						&nbsp;�� ������ ���ν� ���ݰ�꼭 ���� ��� : 
						<input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("PP_CHK")).equals("0")){%>checked<%}%>>�ſ� �յ� ���� 
						<input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("PP_CHK")).equals("1")){%>checked<%}%>>�Ͻù���
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="3" class="fss">&nbsp;&nbsp;&nbsp;* 1. �������� ���Ⱓ ������ ���Բ� ȯ���� �帳�ϴ�.<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2. �������� �̿�Ⱓ���� �ſ� ���� �ݾ׾� �����Ǹ�, ��� ������ ȯ�ҵǴ� ���� �ƴմϴ�.<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3. ���ô뿩��� ������ ( &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;)����ġ �뿩�Ḧ �����ϴ� ���Դϴ�.<br>
			<%//if(base.getCar_gu().equals("1") && fee.getRent_st().equals("1")){%>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4. �ʱ� ���Ա� (������, ������, ���ô뿩��)�� ������� 2���������� (��)�Ƹ���ī�� �ԱݵǾ�� �մϴ�.
			<%//}%>
		</td>
	</tr>
	<tr>
		<td colspan="3" class="right fss">
			( ����ȣ : <%=rent_l_cd%>, Page 1/2, 
			<%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){ // �°�%>
				<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_SUC_RENT_DT")))%>
			<%} else {%>
				<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%>
			<%}%>
			)
		</td>
	</tr>