<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<tr>
	<td class='doc'>
		<div style='text-align: center;'>
			<h1 style='margin-bottom: 0px; display: inline-block;'>CMS 출금이체 신청서</h1>
			<span style='font-size: 1.75em; font-weight: bold; margin-left: 10px;'>
				[
				<input type='checkbox' checked disabled>신규
				<input type='checkbox' disabled>변경
				<input type='checkbox' disabled>해지
				]
			</span>
		</div>
		
		<div style='margin-top: 30px;'>
			<div class='style2' style='font-weight: bold; margin: 5px 0px;'>수납기관 및 요금 종류</div>
			<table style='text-align: center; font-size: 0.95em !important;''>
				<tr>
					<th>수납기관명</th>
					<td colspan='3'>(주)아마존카</td>
				</tr>
				<tr>
					<th width='18%'>대표자</th>
					<td width='30%'>조성희</td>
					<th width='22%'>사업자등록번호</th>
					<td width='30%'>128-81-47957</td>
				</tr>
				<tr>
					<th>사업장주소</th>
					<td>서울 영등포구 의사당대로 8, 802 호(여의도동,삼환까뮤빌딩)</td>
					<th>수납 요금종류</th>
					<td>월대여료, 연체이자, 해지정산금, 면책금, 과태료,초과운행대여료</td>
				</tr>
			</table>
		</div>
		<div style='font-weight: 700; color: red; font-size: 0.85em;'>
			★ 사업자인경우라도 통장 예금주 “OOO(사업자상호) or OOO 님” 신청서에 주민번호(생년월일) 6 자를 꼭 기재해주세요.<br>
			★ Fms 입력시 “통장 예금주”랑 같은 “주민등록번호”로 등록해야 정상신청 됩니다.<br>
			<span style='text-decoration: underline; font-weight: 900;'>
				※ 기업은행 평생계좌 사용 불가합니다 / 기업자유예금 은행명을 확인 후 작성 및 신청해주세요.
			</span> 
		</div>
		
		<div style='margin-top: 20px;'>
			<div class='style2' style='font-weight: bold; margin: 5px 0px;'>출금이체 신청 내용<span style='font-weight: normal; font-size: 0.925em;'>(신청고객 기재란)</span></div>
			<table style='font-size: 0.95em !important;'>
				<tr>
					<th width='18%'>상호</th>
					<td width='30%'>
						<%if(!String.valueOf(ht.get("FIRM_NM")).equals("")){ %>
							<%=ht.get("FIRM_NM")%>
						<%} %>
					</td>
					<th width='22%'>차량번호</th>
					<td width='30%'>
						<%if(!String.valueOf(ht.get("CAR_NO")).equals("")){ %>
							<%=ht.get("CAR_NO")%>
						<%} %>
					</td>
				</tr>
				<tr>
					<th style='color: red;'>통장계좌예금주명</th>
					<td>
						<%if(!String.valueOf(ht.get("CMS_DEP_NM")).equals("")){ %>
							<%=ht.get("CMS_DEP_NM")%>
						<%} %>
					</td>
					<th style='color: red;'>
						출금계좌예금주"이름"<br>
						주민번호 6자리<br>
						(생년월일)
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
					<th>금융기관명</th>
					<td>
						<%if(!String.valueOf(ht.get("CMS_BANK")).equals("")){ %>
							<%=ht.get("CMS_BANK")%>
						<%} %>
					</td>
					<th style='color: red;'>
						출금계좌예금주"사업자"<br>
						법인사업자등록번호기재<br>
					</th>
					<td>
<%-- 						<%if( !String.valueOf(ht.get("CLIENT_ST")).equals("개인") && String.valueOf(ht.get("CMS_DEP_NM")).contains(String.valueOf(ht.get("FIRM_NM")))){ %> --%>
							<%if( String.valueOf(ht.get("CMS_DEP_SSN")).length() == 10 || String.valueOf(ht.get("CMS_DEP_SSN")).length() == 12 ){ %>
								<%=ht.get("CMS_DEP_SSN")%>
							<%}%>
<%-- 						<%}%> --%>
					</td>
				</tr>
				<tr>
					<th style='color: red;'>출금 계좌번호</th>
					<td>
						<%if(!String.valueOf(ht.get("CMS_ACC_NO")).equals("")){ %>
							<%=ht.get("CMS_ACC_NO")%>
						<%} %>
					</td>
					<th>예금주 휴대전화</th>
					<td>
						<%if(!String.valueOf(ht.get("CMS_M_TEL")).equals("")){ %>
							<%=ht.get("CMS_M_TEL")%>
						<%} %>
					</td>
				</tr>
				<tr>
					<th>신청인명</th>
					<td>
						<%if(!String.valueOf(ht.get("FIRM_NM")).equals("")){ %>
							<%=ht.get("FIRM_NM")%>
						<%} %>
					</td>
					<th>예금주와의 관계</th>
					<td></td>
				</tr>
				<tr>
					<th>신청인 연락처</th>
					<td>
						<%if(!String.valueOf(ht.get("TELNO")).equals("")){ %>
							<%=ht.get("TELNO")%>
						<%} %>
					</td>
					<th>신청인 휴대번호</th>
					<td>
						<%if(!String.valueOf(ht.get("MOBILE")).equals("")){ %>
							<%=ht.get("MOBILE")%>
						<%} %>
					</td>
				</tr>
			</table>
		</div>
		
		<div style='border: 1px solid #000; border-bottom: none; padding: 10px;'>
			<div style='font-weight: bold;'>[개인정보 수집 및 이용 동의]</div>
			<div style='margin: 10px; font-size: 0.925em;'>	
				- 수집 및 이용목적 : CMS 출금이체를 통한 요금수납<br>
				- 수집항목 : 성명, 전화번호, 휴대폰번호, 금융기관명, 계좌번호<br>
				- 보유 및 이용기간 : 수집, 이용 동의일로부터 CMS 출금이체 종료일(해지일) 5 년까지<br>
				- 신청자는 개인정보 수집 및 이용을 거부할 권리가 있으며, 권리행사시 출금이체 신청이 거부될 수 있습니다. 
			</div>
			<div style='text-align: right;'>
				동의함<input type='checkbox' checked disabled>
				동의안함<input type='checkbox' disabled>
			</div>
		</div>
		
		<div style='border: 1px solid #000; border-bottom: none; padding: 10px;'>
			<div style='font-weight: bold;'>[개인정보 제3자 제공 동의]</div>
			<div style='margin: 10px; font-size: 0.925em;'>	
				- 개인정보를 제공받는 자 : 사단법인 금융결제원, 고려 CMS<br>
				- 개인정보를 제공받는 자의 개인정보 이용 목적<br>
				: CMS 출금이체 서비스 제공 및 출금동의 확인, 출금이체 신규등록 및 해지 사실 통지<br>
				- 제공하는 개인정보의 항목<br>
				: 성명, 금융기관명, 계좌번호, 생년월일, 전화번호, (은행 등 금융회사 및 이용기관 보유)휴대폰번호<br>
				- 개인정보를 제공받는 자의 개인정보 보유 및 이용기간<br>
				: CMS 출금이체 서비스 제공 및 출금동의 확인 목적을 달성할 때까지<br>
				- 신청자는 개인정보에 대해 금융결제원에 제공하는 것을 거부할 권리가 있으며, 거부시 출금이체 신청이 거부될 수
				있습니다. 
			</div>
			<div style='text-align: right;'>
				동의함<input type='checkbox' checked disabled>
				동의안함<input type='checkbox' disabled>
			</div>
		</div>
		
		<div style='border: 1px solid #000; padding: 10px; background-color: #ededed;'>
			<div style='font-weight: bold;'>[출금이체 동의여부 및 해지사실 통지 안내]</div>
			<div style='margin: 10px; font-size: 0.925em;'>	
				은행 등 금융회사 및 금융결제원은 CMS 제도의 안정적 운영을 위하여 고객의 (은행 등 금융회사 및 이용기관 보유)
				연락처 정보를 활용하여 문자메세지, 유선 등으로 고객의 출금이체 동의여부 및 해지사실을 통지할 수 있습니다.
			</div>
			<div style='text-align: right;'>
				동의함<input type='checkbox' checked disabled>
				동의안함<input type='checkbox' disabled>
			</div>
		</div>
		
		<div style='margin-top: 5px;'>
			상기 금융거래정보의 제공 및 개인정보의 수집 및 이용, 제 3 자 제공에 동의하며 CMS 출금이체를 신청합니다.
		</div>
		
		<div style='margin-top: 20px; text-align: center; font-weight: bold;'>
			<%=AddUtil.getDate(1)%> &nbsp;&nbsp;년
			&nbsp;&nbsp;&nbsp;<%=AddUtil.getDate(2)%>&nbsp;&nbsp;월
			&nbsp;&nbsp;&nbsp;<%=AddUtil.getDate(3)%>&nbsp;&nbsp;일
		</div>
		
		<div style='text-align: right; margin-top: 20px;'>
			<div style='margin-bottom: 10px;'>
				<span style='font-weight: bold;'>신청인:</span> 
				<div style='display: inline-block; width: 80px; border-bottom: 1px solid #000;'></div> 인 또는 서명
			</div>
			<div>
				(신청인과 예금주가 다를 경우)
				<span style='font-weight: bold;'>예금주:</span> 
				<div style='display: inline-block; width: 80px; border-bottom: 1px solid #000;'></div> 인 또는 서명</div>
		</div>
		
		<div style='margin-top: 20px;'>
			주) 1. 인감 또는 서명은 해당 예금계좌 사용인감 또는 서명을 날인하여야 합니다. <br>
			<span style='margin-left: 22px;'>2. 기존 신청내용을 변경하고자 하는 경우에는 먼지 해지신청을 하고 신규 작성을 하여야 합니다.</span><br>
			<span style='margin-left: 22px;'>3. 주계약자와 예금주가 다른 경우 반드시 예금주의 별도 서명을 받아야 합니다.</span>
		</div>
		
	</td>
</tr>