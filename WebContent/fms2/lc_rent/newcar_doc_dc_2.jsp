<%@ page language="java" contentType="text/html;charset=euc-kr"%>
	<tr>
   		<td height=15 class="divide_page" style="padding-top: 25px;"></td>
	</tr>
	<tr>
		<td colspan="2" class="doc1">
			<table class="center">
				<tr>
					<th rowspan="3" width=5%>����<br>���</th>
					<th rowspan="2" width=10%>�ڵ���ü<br>��û</th>
					<td colspan="4" class="left pd"><span class="style2">�� ���� CMS �����ü ��û�� �ۼ�</span></td>
				</tr>
				<tr>
					<td>�ڵ���ü ���</td>
					<td colspan="3" class="left pd">���뿩��, ��ü����, ���������, ��å��, ���·�, �ʰ�����뿩��</td>
				</tr>
				<tr>
					<th>���� �Ա�<br>(���༱��)</th>
					<td colspan="4" class="left pd">���� 140-004-023871 &nbsp;&nbsp;�ϳ� 188-910025-57904 &nbsp;&nbsp;��� 221-181337-01-012 &nbsp;&nbsp;���� 140-003-993274 (�λ�)<br>
						���� 385-01-0026-124&nbsp;&nbsp;�츮 103-293206-13-001 &nbsp;���� 367-17-014214&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���� 140-004-023856 (����)</td>
				</tr>
			</table>
		</td>
	</tr>
<%-- 	<%if(rtn_run_amt == 0){ // ȯ�޴뿩�ᰡ 0�̸� ���� ���%> --%>
	<%if(first_rent_dt < 20220415){ // ���� ������� 2022.04.15 �����̸� ���� ��� %>
	<tr>
		<td colspan="2"><span class=style2>4. �� �� �� ��</span></td>
	</tr>
	<tr>
		<td colspan="2" class="doc1 right">
			<table>	
				<tr>
					<th width=14%><input type="checkbox" name="checkbox" value="checkbox" <%if(ext_gin.getGi_st().equals("1")){%> checked <%}%>>��&nbsp;&nbsp;&nbsp;&nbsp; ��<br>
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(ext_gin.getGi_st().equals("0")){%> checked <%}%>>���Ը���</th>
					<td class="pd">�������� ���Ⱓ ���� �Ӵ����� �Ǻ����ڷ� �ϴ� ����(����)������������( 
						<%if(ext_gin.getGi_st().equals("1")){%>
						<%-- <%=AddUtil.parseDecimal(AddUtil.ten_thous(ext_gin.getGi_amt()))%>����, --%>
						<%=AddUtil.parseDecimal(ext_gin.getGi_amt())%>��,
						<%=fee.getCon_mon()%>���� 
						<%}else{%>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  ��, &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����
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
	<%} %>
	<tr>
		<td colspan="2">
<%-- 			<%if(rtn_run_amt == 0){ // ȯ�޴뿩�ᰡ 0�̸� ���� ��� %> --%>
			<%if(first_rent_dt < 20220415){ // ���� ������� 2022.04.15 �����̸� ���� ��� %>
				<span class=style2>5. Ư �� �� ��</span>
			<%} else{ // ȯ�޴뿩�� �� �ִ� ��� �ű� ���_20220415 ���� %>
				<span class=style2>4. Ư �� �� ��</span>
			<%} %>
		</td>
	</tr>
	<tr>
		<td colspan="2" class="doc1">
			<table>
				<tr>
					<th width=10%>����</th>
					<th colspan="4">�� ��</th>
				</tr>
				<tr>
					<th>����<br>����Ÿ�</th>
<%-- 					<%if(rtn_run_amt == 0){ // ȯ�޴뿩�ᰡ 0�̸� ���� ��� %> --%>
					<%if(first_rent_dt < 20220415){ // ���� ������� 2022.04.15 �����̸� ���� ��� %>
						<td colspan="4" class="pd">
							(1) ��������Ÿ� : <span class="style2 point"><%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%>km����/ 1��, �ʰ� 1km�� (<%=AddUtil.parseDecimal(fee_etc.getOver_run_amt())%>)��[�ΰ�������]�� �ʰ�����뿩��</span>�� �ΰ��ȴ�.<br>						
							(2) ���Կɼ� ���� �ʰ�����뿩�� : �⺻���� ���׸���, �Ϲݽ��� 50%�� ����<br> 
							(3) �ʰ�����Ÿ� ��� : �뿩 �����(�ߵ����� ����) ������ ����Ÿ��� [���� ��������Ÿ� X �뿩�Ⱓ] �� �ʰ��� ���, 
							 �뿩 ���� �Ǵ� �ߵ����� ������ Ȯ�ε� ����Ÿ��� �ʰ�����Ÿ��� �����ϰ�, ����� �ߵ������ÿ��� ��������Ÿ��� 
							 �ϴ����� ȯ���Ͽ� �ʰ�����Ÿ��� �����Ѵ�. �ʰ�����Ÿ� ������ �⺻�����Ÿ� 1000km�� �����ϰ� �����ϱ�� �Ѵ�.<br>
							(4) ������ ����� ��ü �� ����Ÿ� ���۽� ��������Ÿ��� 2�踦 ������ ������ �����Ͽ� �ʰ�����Ÿ��� �����Ѵ�.<br>
							(5) ��������Ÿ��� �ʰ��Ͽ� ������ ���¿��� �������� �ϰ��� �� ���, �ʰ�����뿩�Ḧ �����Ͽ��� ������ ������ �����ϴ�.  
							 ��, �Ƹ���ī�� �ʰ�����뿩���� ���������� �����ϴ� ��쿡�� ���� ���Ⱓ�� ��������Ÿ��� ����Ⱓ
							 �� ��������Ÿ��� �ջ��Ͽ� ���� �뿩 ����� �ʰ�����Ÿ��� �����Ѵ�.<br>
							(6) �ʰ�����뿩�� = �ʰ�����Ÿ�(km) X �ʰ� 1km�� �ʰ�����뿩��(��) (�ΰ�������)<br>
							�� <span class="style2 point">������ ������ ����Ÿ� : (&nbsp;&nbsp;&nbsp;<%if(fee_etc.getOver_bas_km()==0){%> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%}else{%><%=AddUtil.parseDecimal(fee_etc.getOver_bas_km())%><%}%>&nbsp;&nbsp;&nbsp;)km</span>, ������ ����Ÿ��� ������ ���ÿ��� �����ϰ�, �ʰ�����Ÿ�
							 �������� �������� ��´�. ������ ���ÿ��� �ʰ�����Ÿ� ������ �⺻�����Ÿ� 1000km�� �����ϰ� �����Ѵ�.
						</td>
					<%} else{ // ȯ�޴뿩�� �� �ִ� ��� �ű� ���_20220415 ���� %>
						<td colspan="4" class="pd">
							(1) ��������Ÿ� : <span class="point">( <%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%> )km����/1��</span><br>
							&nbsp;&nbsp;<span class="point">��������Ÿ� ���� �����</span> �Ӵ����� <span class="point">�̿��� 1km�� ( <%if(!fee_etc.getRtn_run_amt_yn().equals("0")){%> ������ <%}else{%> <%=AddUtil.parseDecimal(rtn_run_amt)%> <%}%> )��</span>(�ΰ�������)<span class="point">�� ȯ�޴뿩��</span>�� �����ο��� �����ϰ�,<br> 
							&nbsp;&nbsp;<span class="point">��������Ÿ� �ʰ� �����</span> �������� <span class="point">�ʰ� 1km�� ( <%=AddUtil.parseDecimal(fee_etc.getOver_run_amt())%> )��</span>(�ΰ�������)<span class="point">�� �ʰ�����뿩��</span>�� �Ӵ��ο��� �����Ͽ��� �Ѵ�.<br>
							(2) ���Կɼ� ���� ȯ�޴뿩�� : �⺻���� ������, �Ϲݽ��� 40%�� ����<br>
							&nbsp;&nbsp;&nbsp;���Կɼ� ���� �ʰ�����뿩�� : �⺻���� ���׸���, �Ϲݽ��� 40%�� ����<br>
							(3) (��������Ÿ� ���� �����) �̿���Ÿ� �� (��������Ÿ� �ʰ� �����) �ʰ�����Ÿ� ��� : �뿩 �����(�ߵ����� ����) ������ ����Ÿ��� 
								[���� ��������Ÿ� �� �뿩�Ⱓ]�� �ٸ� ��� �뿩 ���� �Ǵ� �ߵ����� ������ Ȯ�ε� ����Ÿ��� �̿���Ÿ� �� �ʰ�����Ÿ��� �����ϰ�, 
								����� �ߵ������ÿ��� ��������Ÿ��� �ϴ����� ȯ���Ͽ� �̿���Ÿ� �� �ʰ�����Ÿ��� �����Ѵ�.<br>
							(4) ������ ���� �̿뿡 ���� �뿩������ �̿���Ÿ� �߻�, ���� ��� �� ���� �ε�/�ݳ��� Ź�ۿ� ���� �뿩������ ����Ÿ� �߻� �� ������ 
								���� ���� ���� ���� ���� �̿���Ÿ� �Ǵ� ����Ÿ��� �߻� �� �� �����Ƿ� �̿���Ÿ� �� �ʰ�����Ÿ� ������ �⺻�����Ÿ� ��1000km�� �����ϰ� �����ϱ�� �Ѵ�. 
								(�̿���Ÿ� �� �ʰ�����Ÿ��� ��1000km�̳��̸� ��������Ÿ��� ���� ������ ���� ����)<br>
							(5) ������ ����� ��ü �� ����Ÿ� ���۽� ��������Ÿ��� 2�踦 ������ ������ �����Ͽ� �ʰ�����Ÿ��� �����Ѵ�.<br>
							(6) ������ ����� ���� ���Ⱓ�� ��������Ÿ��� ����Ⱓ�� ��������Ÿ��� �ջ��Ͽ� ���� �뿩 ����� �̿���Ÿ� �Ǵ� �ʰ�����Ÿ���
	     						�����ϰ� �뿩����� ��������Ÿ��� ���� ������ ���� ���� ������ (��������Ÿ� ���� �����) �̿��� 1km�� ȯ�޴뿩�� �� (��������Ÿ�
	     						�ʰ� �����) �ʰ�1km�� �ʰ�����뿩��� �Ѵ�.<br>
	     					(7) ȯ�޴뿩��(�ΰ�������) =  �̿���Ÿ�(km) �� �̿��� 1km�� ȯ�޴뿩��(��)(�ΰ�������)<br>
	     						&nbsp;&nbsp;&nbsp;�ʰ�����뿩��(�ΰ�������) = �ʰ�����Ÿ�(km) �� �ʰ� 1km�� �ʰ�����뿩��(��)(�ΰ�������)<br>
	     						&nbsp;&nbsp;&nbsp;��, �̿���Ÿ� �� �ʰ�����Ÿ� ������ �⺻�����Ÿ� ��1000km�� �����ϰ� �����Ѵ�.(�̿���Ÿ� �� �ʰ�����Ÿ��� ��1000km�̳��̸� ��������Ÿ��� ���� ������ ���� ����)<br>
	     					�� <span class="point">������ ������ ����Ÿ� : (&nbsp;<%if(fee_etc.getOver_bas_km()==0){%> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%}else{%><%=AddUtil.parseDecimal(fee_etc.getOver_bas_km())%><%}%>&nbsp;)km</span>, ������ ����Ÿ��� ������ ���ÿ��� �����ϰ�, �̿���Ÿ� �� �ʰ�����Ÿ� 
	    						�������� �������� ��´�. ������ ���ÿ��� �̿���Ÿ� �� �ʰ�����Ÿ� ������ �⺻�����Ÿ� ��1000km�� �����ϰ� �����Ѵ�. (�̿���Ÿ� �� �ʰ�����Ÿ��� ��1000km�̳��̸� ��������Ÿ��� ���� ������ ���� ����)
						</td>
					<%} %>
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
<%-- 					<%if(rtn_run_amt == 0){ // ȯ�޴뿩�ᰡ 0�̸� ���� ��� %> --%>
					<%if(first_rent_dt < 20220415){ // ���� ������� 2022.04.15 �����̸� ���� ��� %>
						<td colspan="4" class="pd">(1) ����� �ߵ������ÿ��� <span class="style2 point">�ܿ��Ⱓ �뿩���� (&nbsp;&nbsp;&nbsp;<%=fee.getCls_r_per()%>&nbsp;&nbsp;&nbsp;)%�� �����</span>�� ����Ͽ��� �Ѵ�.<br>
							&nbsp;&nbsp;&nbsp; * �⺻��������� <b>30%</b>�̸�, ������ ���� ��������� �ٸ��� ����˴ϴ�.<br>
							&nbsp;&nbsp;&nbsp; �� �ܿ��Ⱓ �뿩�� = (�뿩�� �Ѿס�����̿�Ⱓ) X �ܿ��̿�Ⱓ<br>
							&nbsp;&nbsp;&nbsp; �� �뿩�� �Ѿ� = ������ + ���ô뿩�� + (���뿩�� X �Ѱ��Ⱓ���� ���뿩�� ������ Ƚ��)<br>
							(2) ������� ���� : ������ �� ���ô뿩��, �ܿ� ���������� �����ϰ�, ������ ��쿡�� �������� �����Ͽ��� �Ѵ�.<br>
							&nbsp;&nbsp;&nbsp; �� �ߵ� ���� �� <b>7</b>���̳��� �������� ������� �������� ���� ��쿡�� �Ӵ����� ���� 4. ������������ ������ �� �ִ�.<br>
							(3) ������, ���ô뿩��, �ܿ����������� �����ϴ� ���� : ���Ģ��, ���·� �谡�з����, �Ҽۺ�� �� �����������<br>
							&nbsp;&nbsp;&nbsp;&nbsp; ������ȸ��(�ڱ�����)�� ���Ͽ� �Ӵ����� �δ��� �Ǻ�� ���å�� �뿬ü���� ���ߵ���������� <!-- ��ü�뿩�� --> ��̳��뿩��
						</td>
					<%} else{ // ȯ�޴뿩�� �� �ִ� ��� �ű� ���_20220415 ���� %>
						<td colspan="4" class="pd">
							(1) ����� �ߵ������ÿ��� <span class="point">�ܿ��Ⱓ �뿩���� (&nbsp;<%=fee.getCls_r_per()%>&nbsp;)%�� �����</span>�� ����Ͽ��� �Ѵ�.<br>
							&nbsp;&nbsp; * �⺻��������� <b>30%</b>�̸�, ������ ���� ��������� �ٸ��� ����˴ϴ�.<br>
							&nbsp;&nbsp; �� �ܿ��Ⱓ �뿩�� = (�뿩�� �Ѿס�����̿�Ⱓ) X �ܿ��̿�Ⱓ<br>
							&nbsp;&nbsp; �� �뿩�� �Ѿ� = ������ + ���ô뿩�� + (���뿩�� X �Ѱ��Ⱓ���� ���뿩�� ������ Ƚ��)<br>
							(2) ������� ���� : ������ �� ���ô뿩��, �ܿ� ������, ȯ�޴뿩��(�߻���)�� �����ϰ�, ������ ��쿡�� �������� �����Ͽ��� �Ѵ�.<br>
							(3) ������, ���ô뿩��, �ܿ�������, ȯ�޴뿩��(�߻���)�� �����ϴ� ���� : ���Ģ��, ���·� �谡�з����, �Ҽۺ�� �� �������� ��� ������ȸ��(�ڱ�����)�� ���Ͽ� �Ӵ����� �δ��� �Ǻ�� ���å�� �뿬ü���� ���ߵ���������� ��̳��뿩��
						</td>
					<%} %>
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
					<td width=27% class="center"><%if(fee.getOpt_s_amt() > 0){%><%=AddUtil.parseDecimal(fee.getOpt_s_amt()+fee.getOpt_v_amt())%>�� (�ΰ��� ����)<%}else{%>���ԿɼǾ���<%}%></td>
					<th width=14%>���Կɼ�<br>������ ����</th>
					<td width=35% class="pd">�ڹ��ΰ�:���� �Ǵ� �� ������ ������<br>
						�ڰ��ΰ�:���� �Ǵ� ������ �θ�/�ڳ�/�����</td>
				</tr>
				<tr>
					<th>�����ǹݳ�</th>
					<td colspan="4" class="pd">�������� ��� ����ÿ� �������� ���� �����ϰ� ���� �ε� ���� ���·� ������ �ݳ��Ͽ��� �Ѵ�.</td>
				</tr>
				<tr>
					<th class="ht">�� Ÿ</th>
					<td colspan="4">&nbsp;<%=fee_etc.getCon_etc()%></td>
				</tr>
			</table>
		</td>
	</tr>
	<%if(rent_st.equals("1")){%>
	<tr>
		<td class="fss" width="65%">
<%-- 			<%if(rtn_run_amt == 0){ // ȯ�޴뿩�ᰡ 0�̸� ���� ��� %> --%>
			<%if(first_rent_dt < 20220415){ // ���� ������� 2022.04.15 �����̸� ���� ��� %>
				<%if(base.getCar_st().equals("3")){	//���� %>
					�� �� ��༭ 1.�����׿��� 5.Ư����� ������ ������ ÷�ε� �Ƹ���ī �ڵ��� �ü��뿩(����) ����� �켱�Ͽ� ����ȴ�.
				<%}else{ 	//��Ʈ%>
					�� �� ��༭ 1.�����׿��� 5.Ư����� ������ ������ ÷�ε� �Ƹ���ī �ڵ��� ���뿩 ����� �켱�Ͽ� ����ȴ�.
				<%} %>
			<%} else{ // ȯ�޴뿩�� �� �ִ� ��� �ű� ���_20220415 ���� %>
				<%if(base.getCar_st().equals("3")){	//���� %>
					�� �� ��༭ 1.�����׿��� 4. Ư����ױ����� ������ �޸��� �Ƹ���ī �ڵ��� �ü��뿩(����) ����� �켱�Ͽ� ����ȴ�.
				<%}else{ 	//��Ʈ%>
					�� �� ��༭ 1.�����׿��� 4. Ư����ױ����� ������ �޸��� �Ƹ���ī ���뿩 ����� �켱�Ͽ� ����ȴ�.
				<%} %>
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
<%-- 			<%if(rtn_run_amt == 0){ // ȯ�޴뿩�ᰡ 0�̸� ���� ��� %> --%>
			<%if(first_rent_dt < 20220415){ // ���� ������� 2022.04.15 �����̸� ���� ��� %>
				<%if(base.getCar_st().equals("3")){	//���� %>
					�� �� ��༭ 1.�����׿��� 5.Ư����� ������ ������ ÷�ε� �Ƹ���ī �ڵ��� �ü��뿩(����) ����� �켱�Ͽ� ����ȴ�.
				<%}else{ 	//��Ʈ%>
					�� �� ��༭ 1.�����׿��� 5.Ư����� ������ ������ ÷�ε� �Ƹ���ī �ڵ��� ���뿩 ����� �켱�Ͽ� ����ȴ�.
				<%} %>
			<%} else{ // ȯ�޴뿩�� �� �ִ� ��� �ű� ���_20220415 ���� %>
				<%if(base.getCar_st().equals("3")){	//���� %>
					�� �� ��༭ 1.�����׿��� 4. Ư����ױ����� ������ �޸��� �Ƹ���ī �ڵ��� �ü��뿩(����) ����� �켱�Ͽ� ����ȴ�.
				<%}else{ 	//��Ʈ%>
					�� �� ��༭ 1.�����׿��� 4. Ư����ױ����� ������ �޸��� �Ƹ���ī ���뿩 ����� �켱�Ͽ� ����ȴ�.
				<%} %>
			<%} %>
		</td>
	</tr>	
	<%} %>	
	<tr>
		<td colspan="2" class="doc1">
		<%-- <%if(client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){%> --%>
		<%if(cont_etc.getClient_share_st().equals("1")){%>
      	        <!-- ������������ ��� -->
     	 	<table class="center">
				<tr>
					<td height=16 colspan=4 class="center"><span class=style2>�� �� �� &nbsp;&nbsp;: &nbsp;<%if(fee.getRent_st().equals("1")){%><%=AddUtil.getDate(1)%> &nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��<%}else{%><%=AddUtil.getDate3(fee.getRent_dt())%><%}%></span></td>
				</tr>
		        <tr>
		          	<td width="39%" class="name left">&nbsp;&nbsp;<span class=style2>�뿩������(�Ӵ���)</span><br>&nbsp;&nbsp;����� �������� �ǻ���� 8,<br>&nbsp;&nbsp;802ȣ (���ǵ���, �������)<br><br>
		      			&nbsp;&nbsp;<span class=style6>(��)�Ƹ���ī ��ǥ�̻� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;(��)</span></td>
		          	<td colspan="3" class="name left">&nbsp;&nbsp;<span class=style2>�뿩�̿��� (������)</span><br>
		      			&nbsp;&nbsp;�� ����� ������ Ȯ���Ͽ� ����� ü���ϰ� ��༭ 1���� ���� ������.<br>
		      			&nbsp;&nbsp;�� �뿩�̿���<br><br>&nbsp;&nbsp;&nbsp;<div class="style5 style6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
		      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (��)</div></td>
		        </tr>
		        <tr>
		        	<td height="15" rowspan="3" class="fs" align="left">�� ���뺸����(����������)�� �������� (��)�Ƹ���ī�� ü���� ��
		        	<%if(base.getCar_st().equals("3")){	//���� %>&quot;�ڵ��� �ü��뿩(����) ���&quot;<%}else{ //��Ʈ%>&quot;�ڵ��� �뿩�̿� ���&quot;<%} %> 
		        	�� ���Ͽ� �� ������ �����ϰ� �����ΰ� �����Ͽ�(��������)  �� ���� ��ü�� ä�ǡ�ä���� ������ ���� Ȯ���մϴ�.</td>
		          	<td width="13%" rowspan="3"><input type="checkbox" name="checkbox" value="checkbox"><span class=style6>���뺸����</span><br>
		          								<input type="checkbox" name="checkbox" value="checkbox"><span class=style6>����������</span></td>
		          	<td width="9%">�� ��</td>
		          	<td width="39%">&nbsp;<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getRepre_addr()%><%}%>--></td>
		        </tr>
		        <tr>
		          	<td height="15">�������</td>
		          	<td>&nbsp;<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getRepre_ssn1()%>-<%=client.getRepre_ssn2()%><%}%>--></td>
		        </tr>
		        <tr>
		          	<td height="15">����</td>
		          	<td class="right"><!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getClient_nm()%><%}%>-->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(��)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		        </tr>
     	 	</table>
		<%}else{%>
		<!-- ���뺸������ ��� -->			
			<table class="center">
				<tr>
					<td colspan=4 class="center"><span class=style2>�� �� �� &nbsp;&nbsp;:&nbsp;&nbsp; <%if(fee.getRent_st().equals("1")){%><%=AddUtil.getDate(1)%> &nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��<%}else{%><%=AddUtil.getDate3(fee.getRent_dt())%><%}%></span></td>
				</tr>
		        <tr>
		          	<td width="42%" class="name left">&nbsp;&nbsp;<span class=style2>�뿩������(�Ӵ���)</span><br>&nbsp;&nbsp;����� �������� �ǻ���� 8,<br>&nbsp;&nbsp;802ȣ (���ǵ���, �������)<br><br>
		      			&nbsp;&nbsp;<span class=style6>(��)�Ƹ���ī ��ǥ�̻� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;(��)</span>		      			
		      		</td>
		          	<td colspan="3" class="name left">&nbsp;&nbsp;<span class=style2>�뿩�̿��� (������)</span><br>
		      			&nbsp;&nbsp;�� ����� ������ Ȯ���Ͽ� ����� ü���ϰ� ��༭ 1���� ���� ������.<br>
		      			&nbsp;&nbsp;�� �뿩�̿���<br><br>
		      			<%if(fee.getRent_st().equals("1")){%>
		      			&nbsp;&nbsp;&nbsp;<div class="style5 style6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
		      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (��)</div>
		      			<%}else{%>
		      			    <%if(AddUtil.lengthb(client.getFirm_nm()+" "+client.getClient_nm()) < 30){%>
		      			        &nbsp;&nbsp;&nbsp;<div class="style5 style6">&nbsp;&nbsp; 
		      			        <%=client.getFirm_nm()%>
		      			        <%if(!client.getClient_st().equals("2")){%>��ǥ�̻� <%=client.getClient_nm()%><%}%>&nbsp;&nbsp; (��)</div>		      			        
		      			    <%}else{%>
		      			        &nbsp;&nbsp;&nbsp;<div class="style5 style6">
		      			        <%=client.getFirm_nm()%>
		      			        <%if(!client.getClient_st().equals("2")){%>��ǥ�̻� <%=client.getClient_nm()%><%}%>&nbsp; (��)</div>
		      			    <%}%>
		      			<%}%>
		      		</td>
		        </tr>
		        <tr>
		          	<td height="14" rowspan="3" class="fs" align="left">�� ���뺸����(����������)�� �������� (��)�Ƹ���ī�� ü���� ��
		          	<%if(base.getCar_st().equals("3")){	//���� %>&quot;�ڵ��� �ü��뿩(����) ���&quot;<%}else{ //��Ʈ%>&quot;�ڵ��� �뿩�̿� ���&quot;<%} %>
		          	�� ���Ͽ� �� ������ �����ϰ� �����ΰ� �����Ͽ�(��������)  �� ���� ��ü�� ä�ǡ�ä���� ������ ���� Ȯ���մϴ�.</td>
		          	<td width="13%" rowspan="3"><input type="checkbox" name="checkbox" value="checkbox"><span class=style6>���뺸����</span><br>
		          								<input type="checkbox" name="checkbox" value="checkbox"><span class=style6>����������</span></td>
		          	<td width="9%">�� ��</td>
		          	<td width="39%">&nbsp;<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getRepre_addr()%><%}%>--></td>
		        </tr>
		        <tr>
		          	<td height="14">�������</td>
		          	<td>&nbsp;<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getRepre_ssn1()%>-<%=client.getRepre_ssn2()%><%}%>--></td>
		        </tr>
		        <tr>
		          	<td height="14">����</td>
		          	<td class="right" style="padding-right: 23px;">
		          		<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getClient_nm()%><%}%>-->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(��)		          		
		          	</td>
		        </tr>
     	 	</table>  
     	 	<%}%>
     	 	<div id="Layer1" style="position:absolute; margin-top: -130px; margin-left: 205px; z-index:1;"><img src="http://fms1.amazoncar.co.kr/acar/images/stamp.png" width="75" height="75"></div>
     	 	<div id="Layer3" style="position:absolute; margin-top: -111px; margin-left: 617px; z-index:1;"><img src="http://fms1.amazoncar.co.kr/acar/images/rect.png"></div>
     	 	<div id="Layer5" style="position:absolute; margin-top: -47px; margin-left: 615px; z-index:1;"><img src="http://fms1.amazoncar.co.kr/acar/images/tri.png"></div>	
		</td>
	</tr>
	<tr>	        
		<td colspan="2" class="right fss">
			��༭ ��� ��������:
<%-- 			<%if(rtn_run_amt == 0){ // ȯ�޴뿩�ᰡ 0�̸� ���� ��� %> --%>
			<%if(first_rent_dt < 20220415){ // ���� ������� 2022.04.15 �����̸� ���� ��� %>
				2022�� 01��
			<%} else{ // ȯ�޴뿩�� �� �ִ� ��� �ű� ���_20220415 ���� %>
				2022�� 04��
			<%} %> 
		</td>
	</tr>
	<tr>	        
		<td colspan="2" class="right fss">( ����ȣ : <%=rent_l_cd%>, Page 2/2, <%=AddUtil.ChangeDate2(fee.getRent_dt())%> )</td>
	</tr>