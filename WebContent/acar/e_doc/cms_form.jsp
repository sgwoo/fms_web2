<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<tr>
	<td class='doc'>
		<div style='text-align: center;'>
			<h1 style='margin-bottom: 0px; display: inline-block;'>CMS �����ü ��û��</h1>
			<span style='font-size: 1.75em; font-weight: bold; margin-left: 10px;'>
				[
				<input type='checkbox' checked disabled>�ű�
				<input type='checkbox' disabled>����
				<input type='checkbox' disabled>����
				]
			</span>
		</div>
		
		<div style='margin-top: 30px;'>
			<div class='style2' style='font-weight: bold; margin: 5px 0px;'>������� �� ��� ����</div>
			<table style='text-align: center; font-size: 0.95em !important;''>
				<tr>
					<th>���������</th>
					<td colspan='3'>(��)�Ƹ���ī</td>
				</tr>
				<tr>
					<th width='18%'>��ǥ��</th>
					<td width='30%'>������</td>
					<th width='22%'>����ڵ�Ϲ�ȣ</th>
					<td width='30%'>128-81-47957</td>
				</tr>
				<tr>
					<th>������ּ�</th>
					<td>���� �������� �ǻ���� 8, 802 ȣ(���ǵ���,��ȯ��º���)</td>
					<th>���� �������</th>
					<td>���뿩��, ��ü����, ���������, ��å��, ���·�,�ʰ�����뿩��</td>
				</tr>
			</table>
		</div>
		<div style='font-weight: 700; color: red; font-size: 0.85em;'>
			�� ������ΰ��� ���� ������ ��OOO(����ڻ�ȣ) or OOO �ԡ� ��û���� �ֹι�ȣ(�������) 6 �ڸ� �� �������ּ���.<br>
			�� Fms �Է½� ������ �����֡��� ���� ���ֹε�Ϲ�ȣ���� ����ؾ� �����û �˴ϴ�.<br>
			<span style='text-decoration: underline; font-weight: 900;'>
				�� ������� ������� ��� �Ұ��մϴ� / ����������� ������� Ȯ�� �� �ۼ� �� ��û���ּ���.
			</span> 
		</div>
		
		<div style='margin-top: 20px;'>
			<div class='style2' style='font-weight: bold; margin: 5px 0px;'>�����ü ��û ����<span style='font-weight: normal; font-size: 0.925em;'>(��û�� �����)</span></div>
			<table style='font-size: 0.95em !important;'>
				<tr>
					<th width='18%'>��ȣ</th>
					<td width='30%'>
						<%if(!String.valueOf(ht.get("FIRM_NM")).equals("")){ %>
							<%=ht.get("FIRM_NM")%>
						<%} %>
					</td>
					<th width='22%'>������ȣ</th>
					<td width='30%'>
						<%if(!String.valueOf(ht.get("CAR_NO")).equals("")){ %>
							<%=ht.get("CAR_NO")%>
						<%} %>
					</td>
				</tr>
				<tr>
					<th style='color: red;'>������¿����ָ�</th>
					<td>
						<%if(!String.valueOf(ht.get("CMS_DEP_NM")).equals("")){ %>
							<%=ht.get("CMS_DEP_NM")%>
						<%} %>
					</td>
					<th style='color: red;'>
						��ݰ��¿�����"�̸�"<br>
						�ֹι�ȣ 6�ڸ�<br>
						(�������)
					</th>
					<td>
<%-- 						<%if( String.valueOf(ht.get("CMS_DEP_NM")).contains(String.valueOf(ht.get("CLIENT_NM"))) ){ %> --%>
							<%if( String.valueOf(ht.get("CMS_DEP_SSN")).length() == 6 || String.valueOf(ht.get("CMS_DEP_SSN")).length() == 8 ){ %>
								<%=ht.get("CMS_DEP_SSN")%>
							<%} %>
<%-- 						<%} %> --%>
					</td>
				</tr>
				<tr>
					<th>���������</th>
					<td>
						<%if(!String.valueOf(ht.get("CMS_BANK")).equals("")){ %>
							<%=ht.get("CMS_BANK")%>
						<%} %>
					</td>
					<th style='color: red;'>
						��ݰ��¿�����"�����"<br>
						���λ���ڵ�Ϲ�ȣ����<br>
					</th>
					<td>
<%-- 						<%if( !String.valueOf(ht.get("CLIENT_ST")).equals("����") && String.valueOf(ht.get("CMS_DEP_NM")).contains(String.valueOf(ht.get("FIRM_NM")))){ %> --%>
							<%if( String.valueOf(ht.get("CMS_DEP_SSN")).length() == 10 || String.valueOf(ht.get("CMS_DEP_SSN")).length() == 12 ){ %>
								<%=ht.get("CMS_DEP_SSN")%>
							<%}%>
<%-- 						<%}%> --%>
					</td>
				</tr>
				<tr>
					<th style='color: red;'>��� ���¹�ȣ</th>
					<td>
						<%if(!String.valueOf(ht.get("CMS_ACC_NO")).equals("")){ %>
							<%=ht.get("CMS_ACC_NO")%>
						<%} %>
					</td>
					<th>������ �޴���ȭ</th>
					<td>
						<%if(!String.valueOf(ht.get("CMS_M_TEL")).equals("")){ %>
							<%=ht.get("CMS_M_TEL")%>
						<%} %>
					</td>
				</tr>
				<tr>
					<th>��û�θ�</th>
					<td>
						<%if(!String.valueOf(ht.get("FIRM_NM")).equals("")){ %>
							<%=ht.get("FIRM_NM")%>
						<%} %>
					</td>
					<th>�����ֿ��� ����</th>
					<td></td>
				</tr>
				<tr>
					<th>��û�� ����ó</th>
					<td>
						<%if(!String.valueOf(ht.get("TELNO")).equals("")){ %>
							<%=ht.get("TELNO")%>
						<%} %>
					</td>
					<th>��û�� �޴��ȣ</th>
					<td>
						<%if(!String.valueOf(ht.get("MOBILE")).equals("")){ %>
							<%=ht.get("MOBILE")%>
						<%} %>
					</td>
				</tr>
			</table>
		</div>
		
		<div style='border: 1px solid #000; border-bottom: none; padding: 10px;'>
			<div style='font-weight: bold;'>[�������� ���� �� �̿� ����]</div>
			<div style='margin: 10px; font-size: 0.925em;'>	
				- ���� �� �̿���� : CMS �����ü�� ���� ��ݼ���<br>
				- �����׸� : ����, ��ȭ��ȣ, �޴�����ȣ, ���������, ���¹�ȣ<br>
				- ���� �� �̿�Ⱓ : ����, �̿� �����Ϸκ��� CMS �����ü ������(������) 5 �����<br>
				- ��û�ڴ� �������� ���� �� �̿��� �ź��� �Ǹ��� ������, �Ǹ����� �����ü ��û�� �źε� �� �ֽ��ϴ�. 
			</div>
			<div style='text-align: right;'>
				������<input type='checkbox' checked disabled>
				���Ǿ���<input type='checkbox' disabled>
			</div>
		</div>
		
		<div style='border: 1px solid #000; border-bottom: none; padding: 10px;'>
			<div style='font-weight: bold;'>[�������� ��3�� ���� ����]</div>
			<div style='margin: 10px; font-size: 0.925em;'>	
				- ���������� �����޴� �� : ��ܹ��� ����������, ��� CMS<br>
				- ���������� �����޴� ���� �������� �̿� ����<br>
				: CMS �����ü ���� ���� �� ��ݵ��� Ȯ��, �����ü �űԵ�� �� ���� ��� ����<br>
				- �����ϴ� ���������� �׸�<br>
				: ����, ���������, ���¹�ȣ, �������, ��ȭ��ȣ, (���� �� ����ȸ�� �� �̿��� ����)�޴�����ȣ<br>
				- ���������� �����޴� ���� �������� ���� �� �̿�Ⱓ<br>
				: CMS �����ü ���� ���� �� ��ݵ��� Ȯ�� ������ �޼��� ������<br>
				- ��û�ڴ� ���������� ���� ������������ �����ϴ� ���� �ź��� �Ǹ��� ������, �źν� �����ü ��û�� �źε� ��
				�ֽ��ϴ�. 
			</div>
			<div style='text-align: right;'>
				������<input type='checkbox' checked disabled>
				���Ǿ���<input type='checkbox' disabled>
			</div>
		</div>
		
		<div style='border: 1px solid #000; padding: 10px; background-color: #ededed;'>
			<div style='font-weight: bold;'>[�����ü ���ǿ��� �� ������� ���� �ȳ�]</div>
			<div style='margin: 10px; font-size: 0.925em;'>	
				���� �� ����ȸ�� �� ������������ CMS ������ ������ ��� ���Ͽ� ���� (���� �� ����ȸ�� �� �̿��� ����)
				����ó ������ Ȱ���Ͽ� ���ڸ޼���, ���� ������ ���� �����ü ���ǿ��� �� ��������� ������ �� �ֽ��ϴ�.
			</div>
			<div style='text-align: right;'>
				������<input type='checkbox' checked disabled>
				���Ǿ���<input type='checkbox' disabled>
			</div>
		</div>
		
		<div style='margin-top: 5px;'>
			��� �����ŷ������� ���� �� ���������� ���� �� �̿�, �� 3 �� ������ �����ϸ� CMS �����ü�� ��û�մϴ�.
		</div>
		
		<div style='margin-top: 20px; text-align: center; font-weight: bold;'>
			<%=AddUtil.getDate(1)%> &nbsp;&nbsp;��
			&nbsp;&nbsp;&nbsp;<%=AddUtil.getDate(2)%>&nbsp;&nbsp;��
			&nbsp;&nbsp;&nbsp;<%=AddUtil.getDate(3)%>&nbsp;&nbsp;��
		</div>
		
		<div style='text-align: right; margin-top: 20px;'>
			<div style='margin-bottom: 10px;'>
				<span style='font-weight: bold;'>��û��:</span> 
				<div style='display: inline-block; width: 80px; border-bottom: 1px solid #000;'></div> �� �Ǵ� ����
			</div>
			<div>
				(��û�ΰ� �����ְ� �ٸ� ���)
				<span style='font-weight: bold;'>������:</span> 
				<div style='display: inline-block; width: 80px; border-bottom: 1px solid #000;'></div> �� �Ǵ� ����</div>
		</div>
		
		<div style='margin-top: 20px;'>
			��) 1. �ΰ� �Ǵ� ������ �ش� ���ݰ��� ����ΰ� �Ǵ� ������ �����Ͽ��� �մϴ�. <br>
			<span style='margin-left: 22px;'>2. ���� ��û������ �����ϰ��� �ϴ� ��쿡�� ���� ������û�� �ϰ� �ű� �ۼ��� �Ͽ��� �մϴ�.</span><br>
			<span style='margin-left: 22px;'>3. �ְ���ڿ� �����ְ� �ٸ� ��� �ݵ�� �������� ���� ������ �޾ƾ� �մϴ�.</span>
		</div>
		
	</td>
</tr>