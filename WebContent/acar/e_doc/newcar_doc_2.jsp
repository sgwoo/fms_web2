<%@ page language="java" contentType="text/html;charset=euc-kr"%>
	<tr>
		<td colspan="3" class="doc1">
			<table class="center">
				<tr>
					<th rowspan="3" width=5%>����<br>���</th>
					<th rowspan="2" width=10%>�ڵ���ü<br>��û</th>
					<td colspan="4" class="left"><span class="style2">�� ���� CMS �����ü ��û�� �ۼ�</span></td>
				</tr>
				<tr>
					<td>�ڵ���ü ���</td>
					<td colspan="3" class="left pd">���뿩��, ��ü����, ���������, ��å��, ���·�, �ʰ�����뿩��</td>
				</tr>
				<tr>
					<th>���� �Ա�<br>(���༱��)</th>
					<td colspan="4" class="left pd">
						���� 140-004-023871 &nbsp;&nbsp;�ϳ� 188-910025-57904 &nbsp;&nbsp;��� 221-181337-01-012 &nbsp;&nbsp;���� 140-003-993274 (�λ�)<br>
						���� 385-01-0026-124&nbsp;&nbsp;�츮 103-293206-13-001 &nbsp;���� 367-17-014214&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���� 140-004-023856 (����)
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="3"><span class=style2>4. �� �� �� ��</span></td>
	</tr>
	<tr>
		<td colspan="3" class="doc1 right">
			<table>	
				<tr>
					<th width=14%>
						<input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("GI_ST")).equals("����")){%> checked <%}%>>��&nbsp;&nbsp;&nbsp;&nbsp; ��<br>
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(String.valueOf(ht.get("GI_ST")).equals("���Ը���")){%> checked <%}%>>���Ը���
					</th>
					<td class="pd">
						�������� ���Ⱓ ���� �Ӵ����� �Ǻ����ڷ� �ϴ� ����(����)������������( 
						<%if(String.valueOf(ht.get("GI_ST")).equals("����")){%>
							<%=AddUtil.parseDecimal(String.valueOf(ht.get("GI_AMT")))%>��,
							<%=ht.get("CON_MON")%>���� 
						<%}else{%>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��, &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����
					  	<%}%>
					  )�� ��ġ�Ѵ�.<br>
						�� ��, �����뿩����� ��ü, �ߵ����� �����, �ʰ�����뿩�� ��� ���� �� ��࿡�� �߻��� �� �ִ� ��� ä�ǿ� ���ؼ�
						�Ӵ����� �������� ��ġ�� ����(����)���������������� �Ǹ��� ����� �� �ִ�.</td>
				</tr>	
			</table>
			<!-- ��������� ����(2019�� 11�� 13��) -->
			<%-- <table class="doc_s right" style="margin:0px; padding:0px;">
				<tr>
					<th width=45%>���������</th>
					<td><%=AddUtil.parseDecimal(ext_gin.getGi_fee())%>��</td>
				</tr>
			</table> --%>
		</td>
	</tr>
	<tr>
		<td colspan="3"><span class=style2>5. Ư �� �� ��</span></td>
	</tr>
	<tr>
		<td colspan="3" class="doc1">
			<table>
				<tr>
					<th width=10%>����</th>
					<th colspan="4">�� ��</th>
				</tr>
				<tr>
					<th>����<br>����Ÿ�</th>
					<td colspan="4" class="pd">
						(1) ��������Ÿ� : <span class="style2 point"><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGREE_DIST")))%>km����/ 1��, �ʰ� 1km�� (<%=AddUtil.parseDecimal(String.valueOf(ht.get("OVER_RUN_AMT")))%>)��[�ΰ�������]�� �ʰ�����뿩��</span>�� �ΰ��ȴ�.<br>						
						(2) ���Կɼ� ���� �ʰ�����뿩�� : �⺻���� ���׸���, �Ϲݽ��� 50%�� ����<br>  
						(3) �ʰ�����Ÿ� ��� : �뿩 �����(�ߵ����� ����) ������ ����Ÿ��� [���� ��������Ÿ� X �뿩�Ⱓ] �� �ʰ��� ���, 
						 �뿩 ���� �Ǵ� �ߵ����� ������ Ȯ�ε� ����Ÿ��� �ʰ�����Ÿ��� �����ϰ�, ����� �ߵ������ÿ��� ��������Ÿ���  
						 �ϴ����� ȯ���Ͽ� �ʰ�����Ÿ��� �����Ѵ�. �ʰ�����Ÿ� ������ �⺻�����Ÿ� 1000km�� �����ϰ� �����ϱ�� �Ѵ�.<br>
						(4) ������ ����� ��ü �� ����Ÿ� ���۽� ��������Ÿ��� 2�踦 ������ ������ �����Ͽ� �ʰ�����Ÿ��� �����Ѵ�.<br>
						(5) ��������Ÿ��� �ʰ��Ͽ� ������ ���¿��� �������� �ϰ��� �� ���, �ʰ�����뿩���� �����Ͽ��� ������ ������ 
						 �����ϴ�. ��, �Ƹ���ī�� �ʰ�����뿩���� ���������� �����ϴ� ��쿡�� ���� ���Ⱓ�� ��������Ÿ��� ����Ⱓ
						 �� ��������Ÿ��� �ջ��Ͽ� ���� �뿩 ����� �ʰ�����Ÿ��� �����Ѵ�.<br>
						(6) �ʰ�����뿩�� = �ʰ�����Ÿ�(km) X �ʰ� 1km�� �ʰ�����뿩��(��) (�ΰ�������)<br>
						�� <span class="style2 point">������ ������ ����Ÿ� : (&nbsp;&nbsp;&nbsp;
						<%if(String.valueOf(ht.get("OVER_BAS_KM")).equals("0")){%> 
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<%}else{%>
							<%=AddUtil.parseDecimal(String.valueOf(ht.get("OVER_BAS_KM")))%>
						<%}%>&nbsp;&nbsp;&nbsp;)km</span>, ������ ����Ÿ��� ������ ���ÿ��� �����ϰ�, �ʰ�����Ÿ�
						 �������� �������� ��´�. ������ ���ÿ��� �ʰ�����Ÿ� ������ �⺻�����Ÿ� 1000km�� �����ϰ� �����Ѵ�.
					</td>
				</tr>
				<tr>
					<th>�뿩��<br>��ü��</th>
					<td colspan="4" class="pd">
						(1) �뿩�� ��ü�� <span class="style2 point">�⸮ 20%�� ��ü����</span>�� �ΰ��ȴ�.<br>
						(2) �뿩���� ������ 2ȸ�̻� ���������� ��ü�� ��� �Ӵ����� ����� ���� �� �� ������, �� �� �������� ������ ��� �ݳ��Ͽ��� �Ѵ�. �Ӵ����� ���� �ݳ� �䱸���� �ұ��ϰ� �������� ������ �ݳ����� ���� ��쿡�� �Ӵ����� ���Ƿ� ������ ȸ���� �� �ִ�.<br>
						(3) �������� ������ �� �ʱⳳ�Ա��� ������ �� ��࿡ ���� �Ӵ��ο��� �����Ͽ��� �� �뿩���� ������ ������ �� ����.<br>
						(4) ��ü�� ���� ��������� �������� �Ʒ� �ߵ����� ������ ������� �����Ͽ��� �Ѵ�.
					</td>
				</tr>
				<tr>
					<th>�ߵ�������</th>
					<td colspan="4" class="pd">(1) ����� �ߵ������ÿ��� <span class="style2 point">�ܿ��Ⱓ �뿩���� (&nbsp;&nbsp;&nbsp;<%=ht.get("CLS_R_PER")%>&nbsp;&nbsp;&nbsp;)%�� �����</span>�� ����Ͽ��� �Ѵ�.<br>
						&nbsp;&nbsp;&nbsp; * �⺻��������� <b>30%</b>�̸�, ������ ���� ��������� �ٸ��� ����˴ϴ�.<br>
						&nbsp;&nbsp;&nbsp; �� �ܿ��Ⱓ �뿩�� = (�뿩�� �Ѿס�����̿�Ⱓ) X �ܿ��̿�Ⱓ<br>
						&nbsp;&nbsp;&nbsp; �� �뿩�� �Ѿ� = ������ + ���ô뿩�� + (���뿩�� X �Ѱ��Ⱓ���� ���뿩�� ������ Ƚ��)<br>
									(2) ������� ���� : ������ �� ���ô뿩��, �ܿ� ���������� �����ϰ�, ������ ��쿡�� �������� �����Ͽ��� �Ѵ�.<br>
						&nbsp;&nbsp;&nbsp; �� �ߵ� ���� �� <b>7</b>���̳��� �������� ������� �������� ���� ��쿡�� �Ӵ����� ���� 4. ������������ ������ �� �ִ�.<br>
									(3) ������, ���ô뿩��, �ܿ����������� �����ϴ� ���� : ���Ģ��, ���·� �谡�з����, �Ҽۺ�� �� �����������<br>
						&nbsp;&nbsp;&nbsp;&nbsp; ������ȸ��(�ڱ�����)�� ���Ͽ� �Ӵ����� �δ��� �Ǻ�� ���å�� �뿬ü���� ���ߵ���������� <!-- ��ü�뿩�� -->��̳��뿩��
					</td>
				</tr>
				<tr>
					<th>���°��</th>
					<td colspan="4" class="pd">����� �°���� ���� �������� ã�ƾ� �ϸ�, ���°踦 ������ �� ���δ� (��)�Ƹ���ī�� ���������� �Ǵ��Ͽ� �����Ѵ�. ���°������� [������ ����ǥ�� ���� �Һ��ڰ����� 0.8%](�ΰ�������)�� �Ѵ�. (�߰����ŸŻ󿡰� �Ǵ� ��ุ�� 3�����̳� ���°� �Ұ�)</td>
				</tr>
				<tr>
					<th>�Ѵ޹̸�<br>�뿩���</th>
					<td colspan="4" class="pd">�뿩����� �������� �����ϸ�, 1���� �̸� �̿�Ⱓ�� ���� �뿩����� "�̿��ϼ� X (���뿩���30)"���� �Ѵ�.</td>
				</tr>
				<tr>
					<th rowspan="2">���Ⱓ<br>�������<br>�߰���<br>���Կɼ�</th>
					<td colspan="4" class="pd">���Ⱓ ����� �������� �� �뿩�̿� ������ �Ʒ��� ���Կɼǰ��ݿ� ������ �� �ִ� [�߰��� ���� ���ñ�(�߰��� ���Կɼ�)]�� ������.
					<%-- <%if(!base.getCar_st().equals("3")){ %>
					&nbsp;��, �Ϲ����� ������ �� ���� LPG ������ ��쿡�� ������ ������ ���� ���������ڳ� ����ε� ������ �ڰ��� �ִ� �� �Ǵ� �������� �����ϰ� �ִ� ���� ����� ���� ������ ������ �����մϴ�.
					<%} %> --%>
					</td>
				</tr>
				<tr>
					<th width=10%>���Կɼ�<br>����</th>
					<td width=27% class="center">
						<%if(Integer.parseInt(String.valueOf(ht.get("OPT_AMT"))) > 0){%>
							<%=AddUtil.parseDecimal(String.valueOf(ht.get("OPT_AMT")))%>�� (�ΰ��� ����)
						<%}else{%>
							���ԿɼǾ���
						<%}%>
					</td>
					<th width=14%>���Կɼ�<br>������ ����</th>
					<td width=35% class="pd">�ڹ��ΰ�:���� �Ǵ� �� ������ ������<br>
						�ڰ��ΰ�:���� �Ǵ� ������ �θ�/�ڳ�/�����</td>
				</tr>
				<tr>
					<th>�����ǹݳ�</th>
					<td colspan="4" class="pd">�������� ��� ����ÿ� �������� ���� �����ϰ� ���� �ε� ���� ���·� ������ �ݳ��Ͽ��� �Ѵ�.</td>
				</tr>
				<%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){ // �°�%>
					<tr>
						<th class="ht" rowspan="2">�� Ÿ</th>
						<td colspan="4">
						(1) �� ����� <span class="style7">&nbsp;&nbsp;<%=ht.get("RENT_SUC_FIRM_NM")%>&nbsp;&nbsp;</span>�� 
						(��)�Ƹ���ī ���� <%=AddUtil.getDate3(String.valueOf(ht.get("RENT_SUC_RENT_DT")))%> ����Ͽ� �̿��ϰ� �ִ� 
						<%if(String.valueOf(ht.get("CAR_ST")).contains("����")){ // ����%>�ڵ��� �ü��뿩(����)<%}else{	//��Ʈ %>�ڵ��� �뿩�̿�<%} %>
						����� �°��ϴ� ����. 
						&nbsp;���°������ <span class=style7>&nbsp;&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht.get("RENT_SUC_COMMI")))%> ��(�ΰ�������)&nbsp;&nbsp;</span><br>
						(2) ������������ ���� ��࿡ ���� ��ü�� �Ǹ��� �ǹ��� ���� ������ <span class="style7">&nbsp;&nbsp;<%=ht.get("FIRM_NM")%>&nbsp;&nbsp;</span>���� �°��ϴ� ���� ������.<br>
						(3) �°���� ����Ÿ�       <span class=style7>&nbsp;&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht.get("RENT_SUC_DIST")))%><%if(Integer.parseInt(String.valueOf(ht.get("RENT_SUC_DIST"))) == 0 ){%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%}%> km&nbsp;&nbsp;</span>  &nbsp;&nbsp;&nbsp; 20 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;(����������) 
						<span class="style7">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(��)</span><br>
						&nbsp;�� �°���� ����Ÿ��� ���� ��������̸�, �ʰ�����뿩�� ������ �뿩 �����(�ߵ����� ����)�� �°��� ������� �������� �����մϴ�.</td>
					</tr>
					<tr>
						<td colspan="4" style="height:50px;">
							&nbsp;<%=ht.get("CON_ETC")%>
						</td>
					</tr>
				<%} else {%>
					<tr>
						<th class="ht">�� Ÿ</th>
						<td colspan="4">&nbsp;<%=ht.get("CON_ETC")%></td>
					</tr>
				<%} %>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<table width="100%">
				<%if(String.valueOf(ht.get("RENT_ST")).equals("1")){%>
				<tr>
					<td class="fss" width="65%">
						<%if(String.valueOf(ht.get("CAR_ST")).contains("����")){ // ����%>
							�� �� ��༭ 1.�����׿��� 5.Ư����� ������ ������ ÷�ε� �Ƹ���ī �ڵ��� �ü��뿩(����) ����� �켱�Ͽ� ����ȴ�.
						<%}else{ 	//��Ʈ%>
							�� �� ��༭ 1.�����׿��� 5.Ư����� ������ ������ ÷�ε� �Ƹ���ī �ڵ��� ���뿩 ����� �켱�Ͽ� ����ȴ�.
						<%} %>
					</td>
					<td class="fss" width="35%">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ڼ�Ȯ����:
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����
					</td>
				</tr>
				<%}else{ %>
				<tr>
					<td class="fss" width="100%" colspan="2">
						<%if(String.valueOf(ht.get("CAR_ST")).contains("����")){ // ����%>
							�� �� ��༭ 1.�����׿��� 5.Ư����� ������ ������ ÷�ε� �Ƹ���ī �ڵ��� �ü��뿩(����) ����� �켱�Ͽ� ����ȴ�.
						<%}else{ 	//��Ʈ%>
							�� �� ��༭ 1.�����׿��� 5.Ư����� ������ ������ ÷�ε� �Ƹ���ī �ڵ��� ���뿩 ����� �켱�Ͽ� ����ȴ�.
						<%} %>
					</td>
				</tr>	
				<%} %>
			</table>
		</td>	
	</tr>
	<tr>
		<td colspan="3" class="doc1">
<%-- 		<%if(cont_etc.getClient_share_st().equals("1")){%> --%>
		<%-- <%if(client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){%> --%>
     	        <!-- ������������ ��� -->
     	 	<table class="center">
				<tr>
					<td style="height:15px;padding:0px;" colspan=4 class="center">
						<span class=style2>
							�� �� �� &nbsp;&nbsp;:
							&nbsp;&nbsp;&nbsp;<%=AddUtil.getDate(1)%> &nbsp;&nbsp;��
							&nbsp;&nbsp;&nbsp;<%=AddUtil.getDate(2)%>&nbsp;&nbsp;��
							&nbsp;&nbsp;&nbsp;<%=AddUtil.getDate(3)%>&nbsp;&nbsp;��
						</span>
					</td>
				</tr>
		        <tr>
		          	<td width="39%" class="name left">
		          		&nbsp;&nbsp;<span class=style2>�뿩������(�Ӵ���)</span><br>
		          		&nbsp;&nbsp;����� �������� �ǻ���� 8,<br>&nbsp;&nbsp;802ȣ (���ǵ���, �������)<br><br>
		      			<div style='position: relative;'>
			      			&nbsp;&nbsp;<span class=style6>(��)�Ƹ���ī ��ǥ�̻� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;(��)</span>
			      			<img src="http://fms1.amazoncar.co.kr/acar/images/stamp.png" style='position: absolute; width: 75px; height: 75px; top: -35px; left: 200px;'>
		      			</div>
		      		</td>
		          	<td colspan="3" class="name left">&nbsp;&nbsp;<span class=style2>�뿩�̿��� (������)</span><br>
		      			&nbsp;&nbsp;�� ����� ������ Ȯ���Ͽ� ����� ü���ϰ� ��༭ 1���� ���� ������.<br>
		      			&nbsp;&nbsp;�� �뿩�̿���<br><br>
		      			&nbsp;&nbsp;&nbsp;
		      			<div class="style5 style6" style='position: relative;'>
			      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=ht.get("FIRM_NM")%>
			      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (��)
			      			<img src="http://fms1.amazoncar.co.kr/acar/images/rect.png" style='position: absolute; top: -25px; left: 351px;'>
			      		</div>
			      	</td>
		        </tr>
		        <tr>
		        	<td height="15" rowspan="3" class="fs" align="left">�� ���뺸����(����������)�� �������� (��)�Ƹ���ī�� ü���� ��
		        	<%if(String.valueOf(ht.get("CAR_ST")).contains("����")){ // ����%>&quot;�ڵ��� �ü��뿩(����) ���&quot;<%}else{ //��Ʈ%>&quot;�ڵ��� �뿩�̿� ���&quot;<%} %> 
		        	 �� ���Ͽ� �� ������ �����ϰ� �����ΰ� �����Ͽ�(��������)  �� ���� ��ü�� ä�ǡ�ä���� ������ ���� Ȯ���մϴ�.</td>
		          	<td width="13%" rowspan="3">
		          		<span class=style6>����������</span>
		          	</td>
		          	<td width="9%">�� ��</td>
		          	<td width="39%">&nbsp;
<%-- 		          		<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getRepre_addr()%><%}%>--> --%>
						<%=ht.get("REPRE_ADDR") %>
		          	</td>
		        </tr>
		        <tr>
		          	<td height="15">�������</td>
		          	<td>&nbsp;
<%-- 		          	<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getRepre_ssn1()%>-<%=client.getRepre_ssn2()%><%}%>--> --%>
		          		<%=ht.get("REPRE_SSN") %>
		          	</td>
		        </tr>
		        <tr>
		          	<td height="15">����</td>
		          	<td class="right">
<%-- 		          		<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getClient_nm()%><%}%>--> --%>
		          		<div style='display: flex;'>
		          			<div style='width: 80%'>
		          				<%=ht.get("REPRE_NM") %>
		          			</div>
			          		<div style='position: relative;'>
				          		<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(��)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
				     	 		<img src="http://fms1.amazoncar.co.kr/acar/images/tri.png" style='position: absolute; top: -32px; left: 30px;'>
			          		</div>
		          		</div>
		          	</td>
		        </tr>
     	 	</table>	
		</td>
	</tr>
	<tr>	        
		<td colspan="2" class="right fss">��༭ ��� ��������: 2022�� 01��</td>
	</tr>
	<tr>	        
		<td colspan="3" class="right fss">
			( ����ȣ : <%=rent_l_cd%>, Page 2/2, 
			<%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){ // �°�%>
				<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_SUC_RENT_DT")))%>
			<%} else {%>
				<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%>
			<%}%>
			)
		</td>
	</tr>