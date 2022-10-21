<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<tr>
	<td>
		<div style='text-align: center;'>
			<h1 style='display: inline-block;'>신용카드 자동출금 이용 신청서</h1>
			<span style='font-size: 1.75em; font-weight: bold; margin-left: 10px;'>
				(
				<input type='checkbox' checked disabled>신규
				<input type='checkbox' disabled>변경
				<input type='checkbox' disabled>해지
				)
			</span>
		</div>
		
		<div style='margin-top: 5px;'>
			※ 전자금융거래법 관련 규정(시행령 10조)에 의거, 자동이체 신청시에는 반드시 <span style='color:red; font-weight: bold;'>서면/공인인증서/녹취</span>를 통한 예금주/카드주/휴대폰명의자 본인의 동의가 필요합니다.
		</div>
		<div style='margin-top: 2px;'>
			※ 신용카드 이용시 카드이용내역서상에 카드사에 따라 결제대행기관인 <span style='color:red; font-weight: bold;'>나이스</span> 또는 <span style='color:red; font-weight: bold;'>나이스(올더게이트)</span>의 이름으로 청구될 수 있으며, 계좌 출금시에는 통장 내역에 수납기관이 지정한 <span style='color:red; font-weight: bold;'>통장기재내역</span>으로 6자 이내 표시 됩니다.
		</div>
		
		<div style='margin-top: 5px;'>
			<div class='style2' style='margin-top: 5px;'><span style='font-weight: bold;'>수납기관 및 요금 정보</span>(수납기관 기재란)</div>
			<table style='text-align: center; font-size: 0.95em !important;'' class='doc_table' cellspacing=0 cellpadding=0>
				<tr>
					<th style='width: 20%'>수납기관명</th>
					<th style='width: 30%'>자동이체사유</th>
					<th style='width: 25%'>금액</th>
					<th style='width: 25%'>비고</th>
				</tr>
				<tr>
					<td>(주)아마존카</td>
					<td>월대여료,연체이자,해지정산금,면책금,과태료,초과운행대여료</td>
					<td>0원</td>
					<td></td>
				</tr>
			</table>
		</div>
		
		<div style='margin-top: 5px;'>
			<div class='style2' style='margin-top: 5px;'><span style='font-weight: bold;'>납부자 정보</span>(수납기관 기재란)</div>
			<table style='text-align: center; font-size: 0.95em !important;'' class='doc_table' cellspacing=0 cellpadding=0>
				<tr>
					<th colspan='20'>납부자 번호(고객번호)</th>
					<th style='width: 15%'>이체개시 년 월</th>
					<th style='width: 15%'>지정 출금일</th>
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
							<%=String.valueOf(ht.get("C_CMS_START_YM")).substring(0, 4)%>년 <%=String.valueOf(ht.get("C_CMS_START_YM")).substring(4, 6)%>월 
						<%} %>
					</td>
					<td>
					매월
					<%if(!String.valueOf(ht.get("RENT_END_DT")).equals("")){ %>
						<%= String.valueOf(ht.get("RENT_END_DT")).substring(6, 8)%>일
					<%} else if(!String.valueOf(ht.get("C_CMS_DAY")).equals("")){%>
						<%= ht.get("C_CMS_DAY")%>일
					<%}%>
					</td>
				</tr>
			</table>
		</div>
		
		<div style='margin-top: 5px;'>
			<div class='style2' style='margin-top: 5px; style='font-weight: bold;''>신청인 정보 입력</div>
			<table style='text-align: center; font-size: 0.95em !important;'' class='doc_table' cellspacing=0 cellpadding=0>
				<tr>
					<th style='width: 20%'>신청인 성명</th>
					<td style='width: 30%'>
						<%if(!String.valueOf(ht.get("C_FIRM_NM")).equals("")){ %>
							<%=ht.get("C_FIRM_NM")%>
						<%} %>
					</td>
					<th style='width: 20%'>이메일</th>
					<td style='width: 30%'>
						<%if(!String.valueOf(ht.get("C_CMS_EMAIL")).equals("")){ %>
							<%=ht.get("C_CMS_EMAIL")%>
						<%} %>
					</td>
				</tr>
				<tr>
					<th>주소</th>
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
					<th>연락처</th>
					<td>
						<%if(!String.valueOf(ht.get("C_CMS_TEL")).equals("")){ %>
							<%= ht.get("C_CMS_TEL") %>
						<%} %>
					</td>
					<th>휴대폰번호</th>
					<td>
						<%if(!String.valueOf(ht.get("C_CMS_M_TEL")).equals("")){ %>
							<%= ht.get("C_CMS_M_TEL") %>
						<%} %>
					</td>
				</tr>
				<tr>
					<th>결제수단 선택</th>
					<td colspan='3' style='text-align: left; padding-left: 10px;'>신용카드</td>
				</tr>
				<tr>
					<th>카드사</th>
					<td>
						<input type='text' style='border: none;'
							name='c_cms_bank'
							<%if(!String.valueOf(ht.get("C_CMS_BANK")).equals("")){ %>
							value='<%= ht.get("C_CMS_BANK") %>'
							<%} %>
						/>
					</td>
					<th>사업자번호<br>(사업자인경우)</th>
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
					<th>카드주 본인명</th>
					<td>
						<input type='text' style='border: none;'
							name='c_cms_dep_nm'
							<%if(!String.valueOf(ht.get("C_CMS_DEP_NM")).equals("")){ %>
								value='<%= ht.get("C_CMS_DEP_NM") %>'
							<%} %>
						/>
					</td>
					<th>카드번호</th>
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
					<th>카드주 본인<br>주민번호 앞 6자리</th>
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
					<th>카드유효기간</th>
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
						(월/년)
					</td>
				</tr>
			</table>
		</div>
		
		<div style='font-weight: bold;'>
			※ 법인공용카드, 선불카드, 해외발행카드 등 일부 카드는 이용이 불가능할 수 있습니다.<br>
			※ 연체, 잔액부족 등의 사유로 납부가 지연되는 경우가 발생하지 않도록 유의하여 주십시오.
		</div>
		
		<div style='border: 1px solid #000; padding: 3px;'>
			<div style='margin-bottom: 5px;'>
				<div style='font-weight: bold; text-align: center;'><span style='text-decoration: underline;'>자동이체 서비스 이용 약관</span></div>
				<div style='margin: 5px; font-size: 0.925em;'>	
					1.이용자는 본 신청서에 서명하거나 공인인증 및 그에 준하는 전자 인증절차를 통함으로써 본 서비스를 이용할 수 있습니다.<br>
					2.회사는 서비스 제공을 위하여 이용자가 제출한 지급결제수단 정보를 해당 금융기관(통신사 포함)에 제공할 수 있습니다.<br>
					3.자동이체 개시일을 이용자가 지정하지 않은 경우 재화 등을 공급하는 자로부터 사전 통지 받은 납기일을 최초 개시일로 하여, 출금은 이용업체와 협의한 날짜에 계좌출금이 이루어 집니다.<br>
					4.출금이체 금액은 해당 지정 출금일 영업 시간 내에 입금된 예금(지정출금일에 입금된 타점권은 제외)에 한하여 출금 처리 되며, 출금이체 금액의 이의가 있는 경우에는 이용업체에 협의하여 조정키로 합니다.<br>
					5.납기일에 동일한 수종의 자동이체 청구가 있는 경우 이체 우선 순위는 이용자의 거래 금융기관이 정하는 바에 따릅니다.<br>
					6.자동이체 납부일이 영업일이 아닌 경우에는 다음 영업일을 납우일로 합니다.<br>
					7.이용자가 자동이체 신청(신규, 해지, 변경)을 원하는 경우 해당 납기일 30일 전까지 회사에 통지해야 합니다.<br>
					8 .이용자가 제출한 지급결제수단의 잔액(예금한도, 신용한도 등)이 예정 결제금액보다 부족하거나 지급제한, 연체 등 납부자의 과실에 의해 발생하는 손해의 책임은 이용자에게 있습니다.<br>
					9 .이용자가 금융기관 및 회사가 정하는 기간 동안 자동이체 이용 실적이 없는 경우 사전 통지 후 자동이체를 해지할 수 있습니다.<br>
					10.회사는 이용자와의 자동이체서비스 이용과 관련된 구체적인 권리, 의무를 정하기 위하여 본 약관과는 별도로 자동이체서비스이용약관을 제정할 수 있습니다.
				</div>
			</div>
			<div style='margin-bottom: 5px;'>
				<div style='font-weight: bold; text-align: center;'><span style='text-decoration: underline;'>개인정보 수집 및 이용 동의</span></div>
				<div style='margin: 5px; font-size: 0.925em;'>	
					1.수집 및 이용목적 :나이스정보통신(주)자동이체서비스를 통한 요금 수납, 민원처리 및 상담요청 응답<br>
					2.수집항목 :성명, 전화번호, 휴대폰번호, 은행명, 계좌번호, 예금주명, 예금주주민번호앞6자리, 카드번호, 카드사, 카드주, 카드유효기간, 이메일<br>
					3.보유 및 이용기간 :수집 이용 동의일부터 자동이체서비스 종료일(해지일)까지며, 보유는 해지일로부터 5년간 보존 후 파기(관계 법령에 의거)<br>
					4.신청자는 개인정보 수집 및 이용을 거부할 수 있습니다.단, 거부 시 자동이체서비스 신청이 처리되지 않습니다.
				</div>
			</div>
			<div style='margin-bottom: 5px;'>
				<div style='font-weight: bold; text-align: center;'><span style='text-decoration: underline;'>개인정보 취급 위탁</span></div>
				<div style='margin: 5px; font-size: 0.925em;'>	
					1.결제(자동이체)서비스를 통한 요금 수납, 관련 민원처리 및 상담요청 응답을 위하여 개인정보 취급 업무을 나이스정보통신(주)에 위탁·운영하고 있습니다.<br>
					2.위탁 계약시 개인정보보호를 위해 위탁업무 수행 목적 외 개인정보 처리 금지, 기술적·관리적 보호조치, 위탁업무의 목적 및 범위, 재위탁 제한, 개인정보에 대한 접근 제한 등 안정성 확보 조치, 위탁업무와 관련하여 보유하고 있는 개인정보의 관리 현황 점검 등 감독에 관한 사항 등을 명확히 규정한 계약을 서면 보관하고 있습니다.<br>
					3.위탁 업체가 변경될 경우, 변경된 업체 명을 인터넷홈페이지, SMS, 전자우편, 서명, 모사전송 등의 방법으로 공개하겠습니다.
				</div>
			</div>
			<div style='margin-bottom: 5px;'>
				<div style='font-weight: bold; text-align: center;'><span style='text-decoration: underline;'>문자(SMS)발송 동의</span></div>
				<div style='margin: 5px; font-size: 0.925em;'>	
					1.자동이체 동의 및 처리결과 안내(휴대폰 문자전송)송부에 동의합니다.
				</div>
			</div>
		</div>
		
		<div style='margin-top: 5px; font-weight: bold; font-size: 12px;'>
			상기 자동이체 신청과 관련하여 카드주명의자로서 자동이체이서비스 이용약관과 개인정보 수집 및 이용동의, 개인정보 취급 위탁에 동의, 문자(SMS)발송에 동의하며, 자동출금이체서비스를 신청합니다.
		</div>
		
		<div style='margin-top: 10px; display: flex;'>
			<div style='width: 20%; font-size: 14px; font-weight: bold;'>
				<%=AddUtil.getDate(1)%>년
				&nbsp;&nbsp;<%=AddUtil.getDate(2)%>월
				&nbsp;&nbsp;<%=AddUtil.getDate(3)%>일
			</div>
			<div style='text-align: right; width: 80%;'>
				<table style='text-align: center; font-size: 0.95em !important;'' class='doc_table' cellspacing=0 cellpadding=0>
					<tr>
						<th style='width: 15%'>신청인</th>
						<td style='width: 35%'>
							<%if(!String.valueOf(ht.get("C_FIRM_NM")).equals("")){ %>
								<%=ht.get("C_FIRM_NM")%>
							<%} %>
							&nbsp;&nbsp;(인)
						</td>
						<th style='width: 15%'>카드주 동의란</th>
						<td style='width: 35%'>
							<%if(!String.valueOf(ht.get("C_CMS_DEP_NM")).equals("")){ %>
								<%=ht.get("C_CMS_DEP_NM")%>
							<%} %>
							&nbsp;&nbsp;(인)
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<div style='font-weight: bold; text-align: right;'>
			<span style='text-decoration: underline;'>* 신청인과 카드주가 상이한 경우에는 카드주의 동의 필요하며, 날인 또는 서명은 출금통장의 거래날인, 서명 사용</span>
		</div>
		
		<div>
			<input type='button' value='저장 테스트' onclick='javascript: onSave();'/>
		</div>
		
	</td>
</tr>