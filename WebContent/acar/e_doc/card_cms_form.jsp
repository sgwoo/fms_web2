<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<tr>
	<td>
		<div style='text-align: center;'>
			<h1 style='display: inline-block;'>�ſ�ī�� �ڵ���� �̿� ��û��</h1>
			<span style='font-size: 1.75em; font-weight: bold; margin-left: 10px;'>
				(
				<input type='checkbox' checked disabled>�ű�
				<input type='checkbox' disabled>����
				<input type='checkbox' disabled>����
				)
			</span>
		</div>
		
		<div style='margin-top: 5px;'>
			�� ���ڱ����ŷ��� ���� ����(����� 10��)�� �ǰ�, �ڵ���ü ��û�ÿ��� �ݵ�� <span style='color:red; font-weight: bold;'>����/����������/����</span>�� ���� ������/ī����/�޴��������� ������ ���ǰ� �ʿ��մϴ�.
		</div>
		<div style='margin-top: 2px;'>
			�� �ſ�ī�� �̿�� ī���̿볻������ ī��翡 ���� ������������ <span style='color:red; font-weight: bold;'>���̽�</span> �Ǵ� <span style='color:red; font-weight: bold;'>���̽�(�ô�����Ʈ)</span>�� �̸����� û���� �� ������, ���� ��ݽÿ��� ���� ������ ��������� ������ <span style='color:red; font-weight: bold;'>������系��</span>���� 6�� �̳� ǥ�� �˴ϴ�.
		</div>
		
		<div style='margin-top: 5px;'>
			<div class='style2' style='margin-top: 5px;'><span style='font-weight: bold;'>������� �� ��� ����</span>(������� �����)</div>
			<table style='text-align: center; font-size: 0.95em !important;'' class='doc_table' cellspacing=0 cellpadding=0>
				<tr>
					<th style='width: 20%'>���������</th>
					<th style='width: 30%'>�ڵ���ü����</th>
					<th style='width: 25%'>�ݾ�</th>
					<th style='width: 25%'>���</th>
				</tr>
				<tr>
					<td>(��)�Ƹ���ī</td>
					<td>���뿩��,��ü����,���������,��å��,���·�,�ʰ�����뿩��</td>
					<td>0��</td>
					<td></td>
				</tr>
			</table>
		</div>
		
		<div style='margin-top: 5px;'>
			<div class='style2' style='margin-top: 5px;'><span style='font-weight: bold;'>������ ����</span>(������� �����)</div>
			<table style='text-align: center; font-size: 0.95em !important;'' class='doc_table' cellspacing=0 cellpadding=0>
				<tr>
					<th colspan='20'>������ ��ȣ(����ȣ)</th>
					<th style='width: 15%'>��ü���� �� ��</th>
					<th style='width: 15%'>���� �����</th>
				</tr>
				<tr>
					<% 
						int length = rent_l_cd.length();
					%>
					<% for(int i=0; i<20; i++){ %>
						<%if(i < length){ %>
							<%if(i == 0){ %>
								<td style='border-right: 1px dotted; width: 3.5%;'><%=rent_l_cd.charAt(i)%></td>
							<%} else {%>
								<td style='border-right: 1px dotted; border-left: none; width: 3.5%;'><%=rent_l_cd.charAt(i)%></td>
							<%}%>
						<%} else {%>
							<td style='border-right: 1px dotted; border-left: none; width: 3.5%;'></td>
						<%}%>
					<%} %>
					<td>
						<%if(!String.valueOf(ht.get("C_CMS_START_YM")).equals("")){ %>
							<%=String.valueOf(ht.get("C_CMS_START_YM")).substring(0, 4)%>�� <%=String.valueOf(ht.get("C_CMS_START_YM")).substring(4, 6)%>�� 
						<%} %>
					</td>
					<td>
					�ſ�
					<%if(!String.valueOf(ht.get("RENT_END_DT")).equals("")){ %>
						<%= String.valueOf(ht.get("RENT_END_DT")).substring(6, 8)%>��
					<%} else if(!String.valueOf(ht.get("C_CMS_DAY")).equals("")){%>
						<%= ht.get("C_CMS_DAY")%>��
					<%}%>
					</td>
				</tr>
			</table>
		</div>
		
		<div style='margin-top: 5px;'>
			<div class='style2' style='margin-top: 5px; style='font-weight: bold;''>��û�� ���� �Է�</div>
			<table style='text-align: center; font-size: 0.95em !important;'' class='doc_table' cellspacing=0 cellpadding=0>
				<tr>
					<th style='width: 20%'>��û�� ����</th>
					<td style='width: 30%'>
						<%if(!String.valueOf(ht.get("C_FIRM_NM")).equals("")){ %>
							<%=ht.get("C_FIRM_NM")%>
						<%} %>
					</td>
					<th style='width: 20%'>�̸���</th>
					<td style='width: 30%'>
						<%if(!String.valueOf(ht.get("C_CMS_EMAIL")).equals("")){ %>
							<%=ht.get("C_CMS_EMAIL")%>
						<%} %>
					</td>
				</tr>
				<tr>
					<th>�ּ�</th>
					<td colspan='3'>
						<%if(!String.valueOf(ht.get("C_CMS_DEP_POST")).equals("")){ %>
							(<%= ht.get("C_CMS_DEP_POST") %>)
						<%}%>
						<%if(!String.valueOf(ht.get("C_CMS_DEP_ADDR")).equals("")){ %>
							<%= ht.get("C_CMS_DEP_ADDR") %>
						<%} %>
					</td>
				</tr>
				<tr>
					<th>����ó</th>
					<td>
						<%if(!String.valueOf(ht.get("C_CMS_TEL")).equals("")){ %>
							<%= ht.get("C_CMS_TEL") %>
						<%} %>
					</td>
					<th>�޴�����ȣ</th>
					<td>
						<%if(!String.valueOf(ht.get("C_CMS_M_TEL")).equals("")){ %>
							<%= ht.get("C_CMS_M_TEL") %>
						<%} %>
					</td>
				</tr>
				<tr>
					<th>�������� ����</th>
					<td colspan='3' style='text-align: left; padding-left: 10px;'>�ſ�ī��</td>
				</tr>
				<tr>
					<th>ī���</th>
					<td>
						<input type='text' style='border: none;'
							name='c_cms_bank'
							<%if(!String.valueOf(ht.get("C_CMS_BANK")).equals("")){ %>
							value='<%= ht.get("C_CMS_BANK") %>'
							<%} %>
						/>
					</td>
					<th>����ڹ�ȣ<br>(������ΰ��)</th>
					<td>
						<input type='text' style='border: none;'
							name='c_enp_no'
							<%if(!String.valueOf(ht.get("C_ENP_NO")).equals("")){ %>
								value='<%= ht.get("C_ENP_NO") %>'
							<%} %>
						/>
					</td>
				</tr>
				<tr>
					<th>ī���� ���θ�</th>
					<td>
						<input type='text' style='border: none;'
							name='c_cms_dep_nm'
							<%if(!String.valueOf(ht.get("C_CMS_DEP_NM")).equals("")){ %>
								value='<%= ht.get("C_CMS_DEP_NM") %>'
							<%} %>
						/>
					</td>
					<th>ī���ȣ</th>
					<td>
						<% boolean flag = false;
							String cms_acc_no = String.valueOf(ht.get("C_CMS_ACC_NO"));
							flag = !cms_acc_no.equals("");
						%>
						<input type='text' style='border: none;'
							size='4'
							name='c_cms_acc_no_1'
							<%if(flag){%>
								value='<%= cms_acc_no.substring(0, 4)%>'
							<%} %>
						/>
						-
						<input type='text' style='border: none;'
							size='4'
							name='c_cms_acc_no_2'
							<%if(flag){%>
								value='<%= cms_acc_no.substring(4, 8)%>'
							<%} %>
						/>
						-
						<input type='text' style='border: none;'
							size='4'
							name='c_cms_acc_no_3'
							<%if(flag){%>
								value='<%= cms_acc_no.substring(8, 12)%>'
							<%} %>
						/>
						-
						<input type='text' style='border: none;'
							size='4'
							name='c_cms_acc_no_4'
							<%if(flag){%>
								value='<%= cms_acc_no.substring(12, 16)%>'
							<%} %>
						/>
						<%if(flag){ %>
							<input type='hidden' name='c_cms_acc_no' value='' />
						<%} %>
					</td>
				</tr>
				<tr>
					<th>ī���� ����<br>�ֹι�ȣ �� 6�ڸ�</th>
					<td>
						<input type='text' style='border: none;'
							size='6'
							name='c_cms_dep_ssn'
							<%if(!String.valueOf(ht.get("C_CMS_DEP_SSN")).equals("")){ %>
								value='<%= ht.get("C_CMS_DEP_SSN") %>'
							<%} %>
						/>
					- *******
					</td>
					<th>ī����ȿ�Ⱓ</th>
					<td>
						<input type='text' style='border: none;'
							size='2'
							name='c_mm'
							<%if(!String.valueOf(ht.get("C_MM")).equals("")){ %>
								value='<%= ht.get("C_MM") %>'
							<%} %>
						/>
						/
						<input type='text' style='border: none;'
							size='2'
							name='c_yyyy'
							<%if(!String.valueOf(ht.get("C_YYYY")).equals("")){ %>
								value='<%= ht.get("C_YYYY") %>'
							<%} %>
						/>
						(��/��)
					</td>
				</tr>
			</table>
		</div>
		
		<div style='font-weight: bold;'>
			�� ���ΰ���ī��, ����ī��, �ؿܹ���ī�� �� �Ϻ� ī��� �̿��� �Ұ����� �� �ֽ��ϴ�.<br>
			�� ��ü, �ܾ׺��� ���� ������ ���ΰ� �����Ǵ� ��찡 �߻����� �ʵ��� �����Ͽ� �ֽʽÿ�.
		</div>
		
		<div style='border: 1px solid #000; padding: 3px;'>
			<div style='margin-bottom: 5px;'>
				<div style='font-weight: bold; text-align: center;'><span style='text-decoration: underline;'>�ڵ���ü ���� �̿� ���</span></div>
				<div style='margin: 5px; font-size: 0.925em;'>	
					1.�̿��ڴ� �� ��û���� �����ϰų� �������� �� �׿� ���ϴ� ���� ���������� �������ν� �� ���񽺸� �̿��� �� �ֽ��ϴ�.<br>
					2.ȸ��� ���� ������ ���Ͽ� �̿��ڰ� ������ ���ް������� ������ �ش� �������(��Ż� ����)�� ������ �� �ֽ��ϴ�.<br>
					3.�ڵ���ü �������� �̿��ڰ� �������� ���� ��� ��ȭ ���� �����ϴ� �ڷκ��� ���� ���� ���� �������� ���� �����Ϸ� �Ͽ�, ����� �̿��ü�� ������ ��¥�� ��������� �̷�� ���ϴ�.<br>
					4.�����ü �ݾ��� �ش� ���� ����� ���� �ð� ���� �Աݵ� ����(��������Ͽ� �Աݵ� Ÿ������ ����)�� ���Ͽ� ��� ó�� �Ǹ�, �����ü �ݾ��� ���ǰ� �ִ� ��쿡�� �̿��ü�� �����Ͽ� ����Ű�� �մϴ�.<br>
					5.�����Ͽ� ������ ������ �ڵ���ü û���� �ִ� ��� ��ü �켱 ������ �̿����� �ŷ� ��������� ���ϴ� �ٿ� �����ϴ�.<br>
					6.�ڵ���ü �������� �������� �ƴ� ��쿡�� ���� �������� �����Ϸ� �մϴ�.<br>
					7.�̿��ڰ� �ڵ���ü ��û(�ű�, ����, ����)�� ���ϴ� ��� �ش� ������ 30�� ������ ȸ�翡 �����ؾ� �մϴ�.<br>
					8 .�̿��ڰ� ������ ���ް��������� �ܾ�(�����ѵ�, �ſ��ѵ� ��)�� ���� �����ݾ׺��� �����ϰų� ��������, ��ü �� �������� ���ǿ� ���� �߻��ϴ� ������ å���� �̿��ڿ��� �ֽ��ϴ�.<br>
					9 .�̿��ڰ� ������� �� ȸ�簡 ���ϴ� �Ⱓ ���� �ڵ���ü �̿� ������ ���� ��� ���� ���� �� �ڵ���ü�� ������ �� �ֽ��ϴ�.<br>
					10.ȸ��� �̿��ڿ��� �ڵ���ü���� �̿�� ���õ� ��ü���� �Ǹ�, �ǹ��� ���ϱ� ���Ͽ� �� ������� ������ �ڵ���ü�����̿����� ������ �� �ֽ��ϴ�.
				</div>
			</div>
			<div style='margin-bottom: 5px;'>
				<div style='font-weight: bold; text-align: center;'><span style='text-decoration: underline;'>�������� ���� �� �̿� ����</span></div>
				<div style='margin: 5px; font-size: 0.925em;'>	
					1.���� �� �̿���� :���̽��������(��)�ڵ���ü���񽺸� ���� ��� ����, �ο�ó�� �� ����û ����<br>
					2.�����׸� :����, ��ȭ��ȣ, �޴�����ȣ, �����, ���¹�ȣ, �����ָ�, �������ֹι�ȣ��6�ڸ�, ī���ȣ, ī���, ī����, ī����ȿ�Ⱓ, �̸���<br>
					3.���� �� �̿�Ⱓ :���� �̿� �����Ϻ��� �ڵ���ü���� ������(������)������, ������ �����Ϸκ��� 5�Ⱓ ���� �� �ı�(���� ���ɿ� �ǰ�)<br>
					4.��û�ڴ� �������� ���� �� �̿��� �ź��� �� �ֽ��ϴ�.��, �ź� �� �ڵ���ü���� ��û�� ó������ �ʽ��ϴ�.
				</div>
			</div>
			<div style='margin-bottom: 5px;'>
				<div style='font-weight: bold; text-align: center;'><span style='text-decoration: underline;'>�������� ��� ��Ź</span></div>
				<div style='margin: 5px; font-size: 0.925em;'>	
					1.����(�ڵ���ü)���񽺸� ���� ��� ����, ���� �ο�ó�� �� ����û ������ ���Ͽ� �������� ��� ������ ���̽��������(��)�� ��Ź����ϰ� �ֽ��ϴ�.<br>
					2.��Ź ���� ����������ȣ�� ���� ��Ź���� ���� ���� �� �������� ó�� ����, ������������� ��ȣ��ġ, ��Ź������ ���� �� ����, ����Ź ����, ���������� ���� ���� ���� �� ������ Ȯ�� ��ġ, ��Ź������ �����Ͽ� �����ϰ� �ִ� ���������� ���� ��Ȳ ���� �� ������ ���� ���� ���� ��Ȯ�� ������ ����� ���� �����ϰ� �ֽ��ϴ�.<br>
					3.��Ź ��ü�� ����� ���, ����� ��ü ���� ���ͳ�Ȩ������, SMS, ���ڿ���, ����, ������� ���� ������� �����ϰڽ��ϴ�.
				</div>
			</div>
			<div style='margin-bottom: 5px;'>
				<div style='font-weight: bold; text-align: center;'><span style='text-decoration: underline;'>����(SMS)�߼� ����</span></div>
				<div style='margin: 5px; font-size: 0.925em;'>	
					1.�ڵ���ü ���� �� ó����� �ȳ�(�޴��� ��������)�ۺο� �����մϴ�.
				</div>
			</div>
		</div>
		
		<div style='margin-top: 5px; font-weight: bold; font-size: 12px;'>
			��� �ڵ���ü ��û�� �����Ͽ� ī���ָ����ڷμ� �ڵ���ü�̼��� �̿����� �������� ���� �� �̿뵿��, �������� ��� ��Ź�� ����, ����(SMS)�߼ۿ� �����ϸ�, �ڵ������ü���񽺸� ��û�մϴ�.
		</div>
		
		<div style='margin-top: 10px; display: flex;'>
			<div style='width: 20%; font-size: 14px; font-weight: bold;'>
				<%=AddUtil.getDate(1)%>��
				&nbsp;&nbsp;<%=AddUtil.getDate(2)%>��
				&nbsp;&nbsp;<%=AddUtil.getDate(3)%>��
			</div>
			<div style='text-align: right; width: 80%;'>
				<table style='text-align: center; font-size: 0.95em !important;'' class='doc_table' cellspacing=0 cellpadding=0>
					<tr>
						<th style='width: 15%'>��û��</th>
						<td style='width: 35%'>
							<%if(!String.valueOf(ht.get("C_FIRM_NM")).equals("")){ %>
								<%=ht.get("C_FIRM_NM")%>
							<%} %>
							&nbsp;&nbsp;(��)
						</td>
						<th style='width: 15%'>ī���� ���Ƕ�</th>
						<td style='width: 35%'>
							<%if(!String.valueOf(ht.get("C_CMS_DEP_NM")).equals("")){ %>
								<%=ht.get("C_CMS_DEP_NM")%>
							<%} %>
							&nbsp;&nbsp;(��)
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<div style='font-weight: bold; text-align: right;'>
			<span style='text-decoration: underline;'>* ��û�ΰ� ī���ְ� ������ ��쿡�� ī������ ���� �ʿ��ϸ�, ���� �Ǵ� ������ ��������� �ŷ�����, ���� ���</span>
		</div>
		
		<div>
			<input type='button' value='���� �׽�Ʈ' onclick='javascript: onSave();'/>
		</div>
		
	</td>
</tr>