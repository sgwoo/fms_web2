<%@ page language="java" contentType="text/html;charset=euc-kr"%>
	<tr>
		<td height=10></td>
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
					<td colspan="3" class="left pd">���뿩��, ��ü����, ���������, ��å��, ���·�</td>
				</tr>
				<tr>
					<th>���� �Ա�<br>(���༱��)</th>
					<td colspan="4" class="left pd">���� 140-004-023871 &nbsp;&nbsp;&nbsp;�ϳ� 188-910025-57904 &nbsp;&nbsp; ��� 221-181337-01-012 &nbsp;&nbsp;���� 140-003-993274 (�λ�)<br>
						���� 385-01-0026-124&nbsp;&nbsp;�츮 103-293206-13-001&nbsp;&nbsp; ���� 367-17-014214&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���� 140-004-023856 (����)</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
   		<td height=5></td>
	</tr>
	<tr>
		<td colspan="2"><span class=style2>4. �� �� �� ��</span></td>
	</tr>
	<tr>
		<td colspan="2" class="doc1 right">
			<table>	
				<tr>
					<th width=14%><input type="checkbox" name="checkbox" value="checkbox" <%if(ext_gin.getGi_st().equals("1")){%> checked <%}%>>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��<br>
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(ext_gin.getGi_st().equals("0")){%> checked <%}%>>���Ը���</th>
					<td class="pd">�������� ���Ⱓ ���� �Ӵ����� �Ǻ����ڷ� �ϴ� ����(����)������������( 
						<%if(ext_gin.getGi_st().equals("1")){%>
						<%=AddUtil.parseDecimal(AddUtil.ten_thous(ext_gin.getGi_amt()))%>����, <%=fee.getCon_mon()%>����
						<%}else{%>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  ����, &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����
					  <%}%>
					  )�� ��ġ�Ѵ�.<br>
						�� ��, �����뿩����� ��ü, �ߵ����� �����, ��å�� ��� ���� �� ��࿡�� �߻��� �� �ִ� ��� ä�ǿ� ���ؼ�<br>
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
		<td colspan="2"><span class=style2>5. Ư �� �� ��</span></td>
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
					<td colspan="4" class="pd">(1) ��������Ÿ� : <span class="style2 point"><%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%>km����/ 1��, �ʰ� 1km�� (<%=AddUtil.parseDecimal(fee_etc.getOver_run_amt())%>)���� �ʰ�����δ��</span>�� �ΰ��ȴ�. (�뿩�����)<br>
												(2) ���Կɼ� ����  �ʰ�����뿩�� : �⺻�ñ� ���׸���, �Ϲݽ��� 50%�� ����<br>
												(3) �ʰ�����Ÿ� ��� : �뿩 �����(�ߵ����� ����) ������ ����Ÿ��� [���� ��������Ÿ� X �뿩�Ⱓ] �� �ʰ��� ���,
												&nbsp;&nbsp;&nbsp;&nbsp; �뿩 ���� �Ǵ� �ߵ����� ������ Ȯ�ε� ����Ÿ��� �ʰ�����Ÿ��� �����ϰ�, ����� �ߵ������ÿ��� ��������Ÿ���
												&nbsp;&nbsp;&nbsp;&nbsp; �ϴ����� ȯ���Ͽ� �ʰ�����Ÿ��� �����Ѵ�. �ʰ�����Ÿ� ������ �⺻�����Ÿ� 1000km�� �����ϰ� �����ϱ�� �Ѵ�.<br>
												(4) ������ ����� ��ü �� ����Ÿ� ���۽� ��������Ÿ��� 2�踦 ������ ������ �����Ͽ� �ʰ�����Ÿ��� �����Ѵ�.<br>
												(5) ��������Ÿ��� �ʰ��Ͽ� ������ ���¿��� �������� �ϰ��� �� ���, �ʰ�����δ���� �����Ͽ��� ������ ������
												&nbsp;&nbsp;&nbsp;&nbsp; �����ϴ�. ��, �Ƹ���ī�� �ʰ�����δ���� ���������� �����ϴ� ��쿡�� ���� ���Ⱓ�� ��������Ÿ��� ����Ⱓ
												&nbsp;&nbsp;&nbsp;&nbsp; �� ��������Ÿ��� �ջ��Ͽ� ���� �뿩 ����� �ʰ�����Ÿ��� �����Ѵ�.<br>
												(6) �ʰ�����δ�� = �ʰ�����Ÿ�(km) X �ʰ� 1km�� �ʰ�����δ��(��)<br>
												�� <span class="style2 point">������ ������ ����Ÿ� : (&nbsp;&nbsp;&nbsp;<%if(fee_etc.getOver_bas_km()==0){%> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%}else{%><%=AddUtil.parseDecimal(fee_etc.getOver_bas_km())%><%}%>&nbsp;&nbsp;&nbsp;)km</span>, ������ ����Ÿ��� ������ ���ÿ��� �����ϰ�, �ʰ�����Ÿ�<br>
												&nbsp;&nbsp;&nbsp; �������� �������� ��´�. ������ ���ÿ��� �ʰ�����Ÿ� ������ �⺻�����Ÿ� 1000km�� �����ϰ� �����Ѵ�.
					</td>
				</tr>
				<tr>
					<th>�뿩��<br>��ü��</th>
					<td colspan="4" class="pd">(1) �뿩�� ��ü�� <span class="style2 point">�⸮ 24%�� ��ü����</span>�� �ΰ��ȴ�.<br>
									(2) 30�� �̻� �뿩�� ��ü�� �Ӵ����� ����� ���� �� �� ������, �� �� �������� ������ ��� �ݳ��Ͽ��� �Ѵ�. �Ӵ�����<br>
			   &nbsp;&nbsp;&nbsp;&nbsp; ���� �ݳ� �䱸���� �ұ��ϰ� �������� ������ �ݳ����� ���� ��쿡�� �Ӵ����� ���Ƿ� ������ ȸ���� �� �ִ�.<br>
									(3) �������� ������ �� �ʱⳳ�Ա��� ������ �� ��࿡ ���� �Ӵ��ο��� �����Ͽ��� �� �뿩���� ������ ������ �� ����.<br>
									(4) ��ü�� ���� ��������� �������� �Ʒ� �ߵ����� ������ ������� �����Ͽ��� �Ѵ�.
					</td>
				</tr>
				<tr>
					<th>�ߵ�������</th>
					<td colspan="4" class="pd">(1) ����� �ߵ������ÿ��� <span class="style2 point">�ܿ��Ⱓ �뿩���� (&nbsp;&nbsp;&nbsp;<%=fee.getCls_r_per()%>&nbsp;&nbsp;&nbsp;)%�� �����</span>�� ����Ͽ��� �Ѵ�.<br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * �⺻��������� <b>30%</b>�̸�, ������ ���� ��������� �ٸ��� ����˴ϴ�.<br>
						&nbsp;&nbsp;&nbsp; �� �ܿ��Ⱓ �뿩�� = (�뿩�� �Ѿס�����̿�Ⱓ) X �ܿ��̿�Ⱓ<br>
						&nbsp;&nbsp;&nbsp; �� �뿩�� �Ѿ� = ������ + ���ô뿩�� + (���뿩�� X �Ѱ��Ⱓ���� ���뿩�� ������ Ƚ��)<br>
									(2) ������� ���� : ������ �� ���ô뿩��, �ܿ� ���������� �����ϰ�, ������ ��쿡�� �������� �����Ͽ��� �Ѵ�.<br>
						&nbsp;&nbsp;&nbsp; �� �ߵ� ���� �� <b>7</b>���̳��� �������� ������� �������� ���� ��쿡�� �Ӵ����� ���� 4. ������������ ������ �� �ִ�.<br>
									(3) ������, ���ô뿩��, �ܿ����������� �����ϴ� ���� : ���Ģ��, ���·� �谡�з����, �Ҽۺ�� �� �����������<br>
						&nbsp;&nbsp;&nbsp;&nbsp; ������ȸ��(�ڱ�����)�� ���Ͽ� �Ӵ����� �δ��� �Ǻ�� ���å�� �뿬ü���� ���ߵ���������� ��ü�뿩��
					</td>
				</tr>
				<tr>
					<th>���°��</th>
					<td colspan="4" class="pd">����� �°���� ���� �������� ã�ƾ� �ϸ�, ���°踦 ������ �� ���δ� (��)�Ƹ���ī�� ���������� �Ǵ��Ͽ� �����Ѵ�. ���°������� ������ ����ǥ�� ���� �Һ��ڰ����� 0.7%�� �Ѵ�. (�߰����ŸŻ󿡰� �Ǵ� ��ุ�� 3�����̳� ���°� �Ұ�)</td>
				</tr>
				<tr>
					<th>�Ѵ޹̸�<br>�뿩���</th>
					<td colspan="4" class="pd">�뿩����� �������� �����ϸ�, 1���� �̸� �̿�Ⱓ�� ���� �뿩����� "�̿��ϼ� X (���뿩���30)"���� �Ѵ�.</td>
				</tr>
				<tr>
					<th rowspan="2">���Ⱓ<br>�������<br>�߰���<br>���Կɼ�</th>
					<td colspan="4" class="pd">���Ⱓ ����� �������� �� �뿩�̿� ������ �Ʒ��� ���Կɼǰ��ݿ� ������ �� �ִ� [�߰��� ���� ���ñ�(�߰��� ���Կɼ�)]�� ������. ��, �Ϲ����� ������ �� ���� LPG ������ ��쿡�� ������ ������ ���� ���������ڳ� ����ε� ������ �ڰ��� �ִ� �� �Ǵ� 
					�������� �����ϰ� �ִ� ���� ����� ���� ������ ������ �����մϴ�.</td>
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
	<tr>
		<td colspan="2" class="fss" height=15>�� �� ��༭�� ������� ���� ������ "�ڵ��� �뿩 ǥ�ؾ��"�� ���մϴ�. (2011.9.23 �����ŷ�����ȸ ����, �Ƹ���ī Ȩ������ ����)</td>
	</tr>
	<tr>
		<td height=2></td>
	</tr>
	<tr>
		<td colspan="2" class="doc1">
		<%-- <%if(client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){%> --%>
		<%if(cont_etc.getClient_share_st().equals("1")){%>
      	        <!-- ������������ ��� -->
     	 	<table class="center">
				<tr>
					<td height=18 colspan=4 class="center"><span class=style2>�� �� �� &nbsp;&nbsp;: &nbsp;<%=AddUtil.getDate3(fee.getRent_dt())%></span></td>
				</tr>
		        <tr>
		          	<td width="39%" class="name left" rowspan="4">&nbsp;&nbsp;<span class=style2>�뿩������(�Ӵ���)</span><br>&nbsp;&nbsp;����� �������� �ǻ���� 8,<br>&nbsp;&nbsp;802ȣ (���ǵ���, ����̾ؾ�����)<br><br>
		      			&nbsp;&nbsp;<span class=style6>(��)�Ƹ���ī ��ǥ�̻� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;(��)</span></td>
		          	<td colspan="3" class="name left">&nbsp;&nbsp;<span class=style2>�뿩�̿��� (������)</span><br>
		      			&nbsp;&nbsp;�� ����� ������ Ȯ���Ͽ� ����� ü���ϰ� ��༭ 1���� ���� ������.<br>
		      			&nbsp;&nbsp;�� �뿩�̿���</span><br><br>&nbsp;&nbsp;&nbsp;<div class="style5 style6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
		      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (��)</div></td>
		        </tr>
		        <tr>
		        	<td height="16" rowspan="3" class="fs">&nbsp;�� ���뺸����(����������)�� �������� (��)�Ƹ���ī�� ü���� �� &quot;�ڵ��� �뿩�̿� ���&quot; �� ���Ͽ� �� ������ �����ϰ� �����ΰ� �����Ͽ�(��������)  �� ���� ��ü�� ä�ǡ�ä���� ������ ���� Ȯ���մϴ�.</td>
		          	<td width="13%" rowspan="3"><input type="checkbox" name="checkbox" value="checkbox"><span class=style6>���뺸����</span><br>
		          								<input type="checkbox" name="checkbox" value="checkbox"><span class=style6>����������</span></td>
		          	<td width="9%">�� ��</td>
		          	<td width="39%">&nbsp;<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getRepre_addr()%><%}%>--></td>
		        </tr>
		        <tr>
		          	<td height="16">�������</td>
		          	<td>&nbsp;<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getRepre_ssn1()%>-<%=client.getRepre_ssn2()%><%}%>--></td>
		        </tr>
		        <tr>
		          	<td height="16">����</td>
		          	<td class="right"><!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getClient_nm()%><%}%>-->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(��)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		        </tr>
     	 	</table>
		<%}else{%>
		<!-- ���뺸������ ��� -->			
			<table class="center">
				<tr>
					<td height=15 colspan=4 class="center"><span class=style2>�� �� �� &nbsp;&nbsp;:&nbsp;&nbsp; <%if(fee.getRent_st().equals("1")){%><%=AddUtil.getDate(1)%> &nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��<%}else{%><%=AddUtil.getDate3(fee.getRent_dt())%><%}%></span></td>
				</tr>
		        <tr>
		          	<td width="39%" class="name left">&nbsp;&nbsp;<span class=style2>�뿩������(�Ӵ���)</span><br>&nbsp;&nbsp;����� �������� �ǻ���� 8,<br>&nbsp;&nbsp;802ȣ (���ǵ���, ����̾ؾ�����)<br><br>
		      			&nbsp;&nbsp;<span class=style6>(��)�Ƹ���ī ��ǥ�̻� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;(��)</span></td>
		          	<td colspan="3" class="name left">&nbsp;&nbsp;<span class=style2>�뿩�̿��� (������)</span><br>
		      			&nbsp;&nbsp;�� ����� ������ Ȯ���Ͽ� ����� ü���ϰ� ��༭ 1���� ���� ������.<br>
		      			&nbsp;&nbsp;�� �뿩�̿���</span><br><br>
		      			<%if(fee.getRent_st().equals("1")){%>
		      			&nbsp;&nbsp;&nbsp;<div class="style5 style6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
		      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (��)</div>
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
		          	<td height="16" rowspan="3" class="fs">&nbsp;�� ���뺸����(����������)�� �������� (��)�Ƹ���ī�� ü���� �� &quot;�ڵ��� �뿩�̿� ���&quot; �� ���Ͽ� �� ������ �����ϰ� �����ΰ� �����Ͽ�(��������)  �� ���� ��ü�� ä�ǡ�ä���� ������ ���� Ȯ���մϴ�.</td>
		          	<td width="13%" rowspan="3"><input type="checkbox" name="checkbox" value="checkbox"><span class=style6>���뺸����</span><br>
		          								<input type="checkbox" name="checkbox" value="checkbox"><span class=style6>����������</span></td>
		          	<td width="9%">�� ��</td>
		          	<td width="39%">&nbsp;<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getRepre_addr()%><%}%>--></td>
		        </tr>
		        <tr>
		          	<td height="16">�������</td>
		          	<td>&nbsp;<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getRepre_ssn1()%>-<%=client.getRepre_ssn2()%><%}%>--></td>
		        </tr>
		        <tr>
		          	<td height="16">����</td>
		          	<td class="right"><!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getClient_nm()%><%}%>-->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(��)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		        </tr>
     	 	</table>  
     	 	<%}%>   	 	
		</td>
	</tr>
	<tr>
		<td height=5></td>
	</tr>
	
	<tr>	        
		<td colspan="2" class="right fss">( ����ȣ : <%=rent_l_cd%>, Page 2/2, <%=AddUtil.ChangeDate2(fee.getRent_dt())%> )</td>
	</tr>	
