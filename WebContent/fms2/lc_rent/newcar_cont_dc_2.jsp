<%@ page language="java" contentType="text/html;charset=euc-kr"%>
	<tr>
		<td height=10></td>
	</tr>
	<tr>
		<td colspan="2" class="doc1">
			<table class="center">
				<tr>
					<th rowspan="3" width=5%>납입<br>방법</th>
					<th rowspan="2" width=10%>자동이체<br>신청</th>
					<td colspan="4" class="left pd"><span class="style2">※ 별지 CMS 출금이체 신청서 작성</span></td>
				</tr>
				<tr>
					<td>자동이체 대상</td>
					<td colspan="3" class="left pd">월대여료, 연체이자, 해지정산금, 면책금, 과태료</td>
				</tr>
				<tr>
					<th>통장 입금<br>(은행선택)</th>
					<td colspan="4" class="left pd">신한 140-004-023871 &nbsp;&nbsp;&nbsp;하나 188-910025-57904 &nbsp;&nbsp; 기업 221-181337-01-012 &nbsp;&nbsp;신한 140-003-993274 (부산)<br>
						국민 385-01-0026-124&nbsp;&nbsp;우리 103-293206-13-001&nbsp;&nbsp; 농협 367-17-014214&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;신한 140-004-023856 (대전)</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
   		<td height=5></td>
	</tr>
	<tr>
		<td colspan="2"><span class=style2>4. 보 증 보 험</span></td>
	</tr>
	<tr>
		<td colspan="2" class="doc1 right">
			<table>	
				<tr>
					<th width=14%><input type="checkbox" name="checkbox" value="checkbox" <%if(ext_gin.getGi_st().equals("1")){%> checked <%}%>>가&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 입<br>
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(ext_gin.getGi_st().equals("0")){%> checked <%}%>>가입면제</th>
					<td class="pd">임차인은 계약기간 동안 임대인을 피보험자로 하는 이행(지급)보증보험증권( 
						<%if(ext_gin.getGi_st().equals("1")){%>
						<%=AddUtil.parseDecimal(AddUtil.ten_thous(ext_gin.getGi_amt()))%>만원, <%=fee.getCon_mon()%>개월
						<%}else{%>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  만원, &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;개월
					  <%}%>
					  )을 예치한다.<br>
						이 때, 차량대여요금의 연체, 중도해지 위약금, 면책금 등과 같이 본 계약에서 발생할 수 있는 모든 채권에 대해서<br>
						임대인은 임차인이 예치한 이행(지급)보증보험증권으로 권리를 행사할 수 있다.</td>
				</tr>	
			</table>
			<!-- 보증보험료 삭제(2019년 11월 13일) -->
			<%-- <table class="doc_s right" style="margin:0px; padding:0px;">
				<tr>
					<th width=45%>보증보험료</th>
					<td><%=AddUtil.parseDecimal(ext_gin.getGi_fee())%>원</td>
				</tr>
			</table> --%>
		</td>
	</tr>
	<tr>
		<td colspan="2"><span class=style2>5. 특 약 사 항</span></td>
	</tr>
	<tr>
		<td colspan="2" class="doc1">
			<table>
				<tr>
					<th width=10%>구분</th>
					<th colspan="4">내 용</th>
				</tr>
				<tr>
					<th>약정<br>운행거리</th>
					<td colspan="4" class="pd">(1) 약정운행거리 : <span class="style2 point"><%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%>km이하/ 1년, 초과 1km당 (<%=AddUtil.parseDecimal(fee_etc.getOver_run_amt())%>)원의 초과운행부담금</span>이 부과된다. (대여종료시)<br>
												(2) 매입옵션 행사시  초과운행대여료 : 기본시근 전액면제, 일반식은 50%만 납부<br>
												(3) 초과운행거리 계산 : 대여 종료시(중도해지 포함) 차량의 운행거리가 [연간 약정운행거리 X 대여기간] 을 초과한 경우,
												&nbsp;&nbsp;&nbsp;&nbsp; 대여 종료 또는 중도해지 시점에 확인된 주행거리로 초과운행거리를 산정하고, 계약의 중도해지시에는 약정운행거리를
												&nbsp;&nbsp;&nbsp;&nbsp; 일단위로 환산하여 초과운행거리를 산정한다. 초과운행거리 산정시 기본공제거리 1000km를 제외하고 산정하기로 한다.<br>
												(4) 임의의 계기판 교체 및 주행거리 조작시 약정운행거리의 2배를 운행한 것으로 간주하여 초과운행거리를 산정한다.<br>
												(5) 약정운행거리를 초과하여 운행한 상태에서 연장계약을 하고자 할 경우, 초과운행부담금을 정산하여야 연장계약 진행이
												&nbsp;&nbsp;&nbsp;&nbsp; 가능하다. 단, 아마존카가 초과운행부담금의 사후정산을 승인하는 경우에는 기존 계약기간의 약정운행거리에 연장기간
												&nbsp;&nbsp;&nbsp;&nbsp; 의 약정운행거리를 합산하여 연장 대여 종료시 초과운행거리를 산정한다.<br>
												(6) 초과운행부담금 = 초과운행거리(km) X 초과 1km당 초과운행부담금(원)<br>
												※ <span class="style2 point">보유차 계약시점 주행거리 : (&nbsp;&nbsp;&nbsp;<%if(fee_etc.getOver_bas_km()==0){%> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%}else{%><%=AddUtil.parseDecimal(fee_etc.getOver_bas_km())%><%}%>&nbsp;&nbsp;&nbsp;)km</span>, 좌측의 주행거리는 보유차 계약시에만 기재하고, 초과운행거리<br>
												&nbsp;&nbsp;&nbsp; 산정시의 기준으로 삼는다. 보유차 계약시에도 초과운행거리 산정시 기본공제거리 1000km를 제외하고 산정한다.
					</td>
				</tr>
				<tr>
					<th>대여료<br>연체시</th>
					<td colspan="4" class="pd">(1) 대여료 연체시 <span class="style2 point">년리 24%의 연체이자</span>가 부과된다.<br>
									(2) 30일 이상 대여료 연체시 임대인은 계약을 해지 할 수 있으며, 이 때 임차인은 차량을 즉시 반납하여야 한다. 임대인의<br>
			   &nbsp;&nbsp;&nbsp;&nbsp; 차량 반납 요구에도 불구하고 임차인이 차량을 반납하지 않을 경우에는 임대인은 임의로 차량을 회수할 수 있다.<br>
									(3) 임차인은 보증금 등 초기납입금을 이유로 본 계약에 따라 임대인에게 지급하여야 할 대여료의 지급을 거절할 수 없다.<br>
									(4) 연체로 인한 계약해지시 임차인은 아래 중도해지 조항의 위약금을 지불하여야 한다.
					</td>
				</tr>
				<tr>
					<th>중도해지시</th>
					<td colspan="4" class="pd">(1) 계약의 중도해지시에는 <span class="style2 point">잔여기간 대여료의 (&nbsp;&nbsp;&nbsp;<%=fee.getCls_r_per()%>&nbsp;&nbsp;&nbsp;)%의 위약금</span>을 배상하여야 한다.<br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * 기본위약금율은 <b>30%</b>이며, 차종에 따라 위약금율이 다르게 적용됩니다.<br>
						&nbsp;&nbsp;&nbsp; ★ 잔여기간 대여료 = (대여료 총액÷계약이용기간) X 잔여이용기간<br>
						&nbsp;&nbsp;&nbsp; ★ 대여료 총액 = 선납금 + 개시대여료 + (월대여료 X 총계약기간동안 월대여료 납입할 횟수)<br>
									(2) 위약금의 정산 : 보증금 및 개시대여료, 잔여 선납금으로 정산하고, 부족할 경우에는 현금으로 지불하여야 한다.<br>
						&nbsp;&nbsp;&nbsp; ★ 중도 해지 후 <b>7</b>일이내에 임차인이 위약금을 완제하지 않을 경우에는 임대인은 위의 4. 보증보험으로 정산할 수 있다.<br>
									(3) 보증금, 개시대여료, 잔여선납금으로 변제하는 순서 : ①범칙금, 과태료 ②가압류비용, 소송비용 등 법적구제비용<br>
						&nbsp;&nbsp;&nbsp;&nbsp; ③차량회수(자구행위)를 위하여 임대인이 부담한 실비용 ④면책금 ⑤연체이자 ⑥중도해지위약금 ⑦연체대여료
					</td>
				</tr>
				<tr>
					<th>계약승계시</th>
					<td colspan="4" class="pd">계약을 승계받을 고객은 임차인이 찾아야 하며, 계약승계를 승인할 지 여부는 (주)아마존카가 종합적으로 판단하여 결정한다. 계약승계수수료는 제조사 가격표상 신차 소비자가격의 0.7%로 한다. (중고차매매상에게 또는 계약만료 3개월이내 계약승계 불가)</td>
				</tr>
				<tr>
					<th>한달미만<br>대여요금</th>
					<td colspan="4" class="pd">대여요금은 월단위로 산정하며, 1개월 미만 이용기간에 대한 대여요금은 "이용일수 X (월대여료÷30)"으로 한다.</td>
				</tr>
				<tr>
					<th rowspan="2">계약기간<br>만료시의<br>중고차<br>매입옵션</th>
					<td colspan="4" class="pd">계약기간 만료시 임차인은 위 대여이용 차량을 아래의 매입옵션가격에 매입할 수 있는 [중고차 매입 선택권(중고차 매입옵션)]을 가진다. 단, 일반인이 구입할 수 없는 LPG 차량의 경우에는 법률의 규정에 따라 국가유공자나 장애인등 일정한 자격이 있는 자 또는 
					법률에서 규정하고 있는 일정 요건을 갖춘 차량만 매입이 가능합니다.</td>
				</tr>
				<tr>
					<th width=10%>매입옵션<br>가격</th>
					<td width=27% class="center"><%if(fee.getOpt_s_amt() > 0){%><%=AddUtil.parseDecimal(fee.getOpt_s_amt()+fee.getOpt_v_amt())%>원 (부가세 포함)<%}else{%>매입옵션없음<%}%></td>
					<th width=14%>매입옵션<br>행사권자 범위</th>
					<td width=35% class="pd">★법인고객:법인 또는 그 법인의 종업원<br>
						★개인고객:본인 또는 본인의 부모/자녀/배우자</td>
				</tr>
				<tr>
					<th>차량의반납</th>
					<td colspan="4" class="pd">임차인은 계약 종료시에 정상적인 마모를 제외하고 최초 인도 받은 상태로 차량을 반납하여야 한다.</td>
				</tr>
				<tr>
					<th class="ht">기 타</th>
					<td colspan="4">&nbsp;<%=fee_etc.getCon_etc()%></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2" class="fss" height=15>※ 본 계약서에 기재되지 않은 사항은 "자동차 대여 표준약관"에 의합니다. (2011.9.23 공정거래위원회 개정, 아마존카 홈페이지 참조)</td>
	</tr>
	<tr>
		<td height=2></td>
	</tr>
	<tr>
		<td colspan="2" class="doc1">
		<%-- <%if(client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){%> --%>
		<%if(cont_etc.getClient_share_st().equals("1")){%>
      	        <!-- 공동임차인일 경우 -->
     	 	<table class="center">
				<tr>
					<td height=18 colspan=4 class="center"><span class=style2>계 약 일 &nbsp;&nbsp;: &nbsp;<%=AddUtil.getDate3(fee.getRent_dt())%></span></td>
				</tr>
		        <tr>
		          	<td width="39%" class="name left" rowspan="4">&nbsp;&nbsp;<span class=style2>대여제공자(임대인)</span><br>&nbsp;&nbsp;서울시 영등포구 의사당대로 8,<br>&nbsp;&nbsp;802호 (여의도동, 까뮤이앤씨빌딩)<br><br>
		      			&nbsp;&nbsp;<span class=style6>(주)아마존카 대표이사 &nbsp;&nbsp;&nbsp;조 &nbsp;&nbsp;&nbsp;성 &nbsp;&nbsp;&nbsp;희 &nbsp;&nbsp;(인)</span></td>
		          	<td colspan="3" class="name left">&nbsp;&nbsp;<span class=style2>대여이용자 (임차인)</span><br>
		      			&nbsp;&nbsp;본 계약의 내용을 확인하여 계약을 체결하고 계약서 1통을 정히 수령함.<br>
		      			&nbsp;&nbsp;위 대여이용자</span><br><br>&nbsp;&nbsp;&nbsp;<div class="style5 style6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
		      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (인)</div></td>
		        </tr>
		        <tr>
		        	<td height="16" rowspan="3" class="fs">&nbsp;본 연대보증인(공동임차인)은 임차인이 (주)아마존카와 체결한 위 &quot;자동차 대여이용 계약&quot; 에 대하여 그 내용을 숙지하고 임차인과 연대하여(공동으로)  동 계약상 일체의 채권·채무를 이행할 것을 확약합니다.</td>
		          	<td width="13%" rowspan="3"><input type="checkbox" name="checkbox" value="checkbox"><span class=style6>연대보증인</span><br>
		          								<input type="checkbox" name="checkbox" value="checkbox"><span class=style6>공동임차인</span></td>
		          	<td width="9%">주 소</td>
		          	<td width="39%">&nbsp;<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getRepre_addr()%><%}%>--></td>
		        </tr>
		        <tr>
		          	<td height="16">생년월일</td>
		          	<td>&nbsp;<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getRepre_ssn1()%>-<%=client.getRepre_ssn2()%><%}%>--></td>
		        </tr>
		        <tr>
		          	<td height="16">성명</td>
		          	<td class="right"><!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getClient_nm()%><%}%>-->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(인)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		        </tr>
     	 	</table>
		<%}else{%>
		<!-- 연대보증인일 경우 -->			
			<table class="center">
				<tr>
					<td height=15 colspan=4 class="center"><span class=style2>계 약 일 &nbsp;&nbsp;:&nbsp;&nbsp; <%if(fee.getRent_st().equals("1")){%><%=AddUtil.getDate(1)%> &nbsp;&nbsp;년&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;월 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;일<%}else{%><%=AddUtil.getDate3(fee.getRent_dt())%><%}%></span></td>
				</tr>
		        <tr>
		          	<td width="39%" class="name left">&nbsp;&nbsp;<span class=style2>대여제공자(임대인)</span><br>&nbsp;&nbsp;서울시 영등포구 의사당대로 8,<br>&nbsp;&nbsp;802호 (여의도동, 까뮤이앤씨빌딩)<br><br>
		      			&nbsp;&nbsp;<span class=style6>(주)아마존카 대표이사 &nbsp;&nbsp;&nbsp;조 &nbsp;&nbsp;&nbsp;성 &nbsp;&nbsp;&nbsp;희 &nbsp;&nbsp;(인)</span></td>
		          	<td colspan="3" class="name left">&nbsp;&nbsp;<span class=style2>대여이용자 (임차인)</span><br>
		      			&nbsp;&nbsp;본 계약의 내용을 확인하여 계약을 체결하고 계약서 1통을 정히 수령함.<br>
		      			&nbsp;&nbsp;위 대여이용자</span><br><br>
		      			<%if(fee.getRent_st().equals("1")){%>
		      			&nbsp;&nbsp;&nbsp;<div class="style5 style6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
		      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (인)</div>
		      			<%}else{%>
		      			    <%if(AddUtil.lengthb(client.getFirm_nm()+" "+client.getClient_nm()) < 30){%>
		      			        &nbsp;&nbsp;&nbsp;<div class="style5 style6">&nbsp;&nbsp; 
		      			        <%=client.getFirm_nm()%>
		      			        <%if(!client.getClient_st().equals("2")){%>대표이사 <%=client.getClient_nm()%><%}%>&nbsp;&nbsp; (인)</div>
		      			    <%}else{%>
		      			        &nbsp;&nbsp;&nbsp;<div class="style5 style6">
		      			        <%=client.getFirm_nm()%>
		      			        <%if(!client.getClient_st().equals("2")){%>대표이사 <%=client.getClient_nm()%><%}%>&nbsp; (인)</div>
		      			    <%}%>
		      			<%}%>
		      		</td>
		        </tr>
		        <tr>
		          	<td height="16" rowspan="3" class="fs">&nbsp;본 연대보증인(공동임차인)은 임차인이 (주)아마존카와 체결한 위 &quot;자동차 대여이용 계약&quot; 에 대하여 그 내용을 숙지하고 임차인과 연대하여(공동으로)  동 계약상 일체의 채권·채무를 이행할 것을 확약합니다.</td>
		          	<td width="13%" rowspan="3"><input type="checkbox" name="checkbox" value="checkbox"><span class=style6>연대보증인</span><br>
		          								<input type="checkbox" name="checkbox" value="checkbox"><span class=style6>공동임차인</span></td>
		          	<td width="9%">주 소</td>
		          	<td width="39%">&nbsp;<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getRepre_addr()%><%}%>--></td>
		        </tr>
		        <tr>
		          	<td height="16">생년월일</td>
		          	<td>&nbsp;<!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getRepre_ssn1()%>-<%=client.getRepre_ssn2()%><%}%>--></td>
		        </tr>
		        <tr>
		          	<td height="16">성명</td>
		          	<td class="right"><!--<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%><%=client.getClient_nm()%><%}%>-->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(인)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		        </tr>
     	 	</table>  
     	 	<%}%>   	 	
		</td>
	</tr>
	<tr>
		<td height=5></td>
	</tr>
	
	<tr>	        
		<td colspan="2" class="right fss">( 계약번호 : <%=rent_l_cd%>, Page 2/2, <%=AddUtil.ChangeDate2(fee.getRent_dt())%> )</td>
	</tr>	
