<%@ page language="java" contentType="text/html;charset=euc-kr"%>
	<tr>
		<td colspan="2"><div align="center">
		<%if(base.getCar_st().equals("3")){	//리스 %>
			<span class=style1>자동차  시설대여(리스) 계약서</span>
		<%}else{ 	//렌트%>
			<span class=style1>자 동 차  대 여 이 용  계 약 서</span>
		<%} %>
		</div></td>
	</tr>
	<tr>
		<td width=76.5%>&nbsp;<img src=http://fms1.amazoncar.co.kr/acar/images/logo_1.png></td>
		<td width=23.5% class="cnum right">
			<table align="right" width="100%">
				<tr>
					<th class="center" width="45%">차량번호</th>
					<td class="center" width="55%"><%=cr_bean.getCar_no()%></td>
				</tr>
			</table>
		</td>
	</tr>	
  	<tr>
 		<td colspan="2" class="doc">
			<table class="style9">
		      	<tr>
			 		<th width="13%">계약번호</th>
			   		<td width="19%">&nbsp;<%=rent_l_cd%></td>
			    	<th width="13%">영업소</th>
			     	<td width="19%">&nbsp;<%=c_db.getNameById(bus_user_bean.getBr_id(),"BRCH")%></td>
			     	<th width="13%">영업담당자</th>
			   		<td width="23%">&nbsp;<%=bus_user_bean.getUser_nm()%>&nbsp;<%=bus_user_bean.getUser_m_tel()%></td>
		   		</tr>
				<tr>
			    	<td class="center title">대여상품 구분</td>
			    	<td colspan="4">
		    		<%if(base.getCar_st().equals("3")){	//리스 %>
						<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_st().equals("3") && !fee.getRent_way().equals("1"))%>checked<%%>>리스 기본식(정비서비스 미포함)   
		    	    	<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_st().equals("3") && fee.getRent_way().equals("1"))%>checked<%%>>리스 일반식(정비서비스 포함)  
					<%}else{ 	//렌트%>
			    		<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_st().equals("1") && !fee.getRent_way().equals("1"))%>checked<%%>>장기렌트 기본식(정비서비스 미포함) 
						<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_st().equals("1") && fee.getRent_way().equals("1"))%>checked<%%>>장기렌트 일반식(정비서비스 포함)
					<%} %>
		    	    </td>
			     	<td><input type="checkbox" name="checkbox" value="checkbox" <%if(rent_st.equals("1") && base.getCar_gu().equals("1"))%>checked<%%>>신차 
			     	    <input type="checkbox" name="checkbox" value="checkbox" <%if(rent_st.equals("1") && base.getCar_gu().equals("0"))%>checked<%%>>보유차
			     	    <input type="checkbox" name="checkbox" value="checkbox" <%if(!rent_st.equals("1"))%>checked<%%>>연장</td>
				</tr>
    		</table>
		</td>
	</tr>
	<tr>
    	<td colspan="2"><span class=style2>1. 고객사항</span></td>
	</tr>
	<tr>
    	<td colspan="2" class="doc">
      		<table>
		        <tr>
		        	<th width="14%">고객구분</th>
		        	<td colspan="6"><input type="checkbox" name="checkbox" value="checkbox" <%if(client.getClient_st().equals("1"))%>checked<%%>>법인 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		        	    <input type="checkbox" name="checkbox" value="checkbox" <%if(!client.getClient_st().equals("1")&&!client.getClient_st().equals("2"))%>checked<%%>>개인사업자 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		        	    <input type="checkbox" name="checkbox" value="checkbox" <%if(client.getClient_st().equals("2"))%>checked<%%>>개인</td>
		        </tr>
		        <tr>
		        	<th>상 호</th>
		        	<td colspan="2">&nbsp;<%=client.getFirm_nm()%></td>
		        	<th>사업자번호</th>
		        	<td colspan="3">&nbsp;<%if(!client.getClient_st().equals("2")){%><%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%><%}%></td>
		        </tr>
		        <tr>
		        	<th>성명(대표자)</th>
		        	<td width="24%">&nbsp;<%if(!client.getClient_st().equals("2")){%><%=client.getClient_nm()%><%}%></td>
		        	<th width="17%">법인(주민)등록번호</th>
		        	<td width="15%">&nbsp;<%if(client.getClient_st().equals("1")){%><%=client.getSsn1()%>-<%=client.getSsn2()%><%}else{%><%if(AddUtil.parseInt(AddUtil.getDate(4)) > 20140806){%><%=client.getSsn1()%><%}else{%><%=client.getSsn1()%>-<%=client.getSsn2()%><%}%><%}%></td>
		        	<th width="4%" rowspan="2">사<br>무<br>실</th>
		        	<th width="10%" class="center">전화번호</th>
		        	<td width="16%">&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></td>
		        </tr>
		        <tr>
		        	<th>주 소(본점)</th>
		        	<td colspan="3">&nbsp;<%=client.getO_addr()%></td>
		        	<th class="center">팩스번호</th>
		        	<td>&nbsp;<%=AddUtil.phoneFormat(client.getFax())%></td>
		        </tr>
		        <tr>
		        	<th>우편물수령주소</th>
		        	<td colspan="3">&nbsp;<%= base.getP_addr()%>&nbsp;<%=base.getTax_agnt()%></td>
		        	<th colspan="2"><span style="letter-spacing: -1px;">대표자휴대폰번호</span></th>
		        	<td>&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
		        </tr>		        
		        <tr>
		        	<th>사용본거지주소</th>
		        	<td colspan="3">&nbsp;<%=site.getAddr()%>&nbsp;<%=site.getR_site()%></td>
		        	<th class="center" colspan="2">운전면허번호</th>
		        	<%	CarMgrBean mgr1 = new CarMgrBean();
                	for(int i = 0 ; i < mgr_size ; i++){
   						CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
   						if(mgr.getMgr_st().equals("차량이용자")){
   							mgr1 = mgr;
   						}
					}                       
              %>
		        	<td>&nbsp;<%=base.getLic_no()%></td>
		        </tr>
	    	</table>	
			<table>
		        <tr>
		        	<th width="12%">구 분</th>
		        	<th width="10%">근무부서</th>
		        	<th width="14%">성 명</th>
		        	<th width="9%">직 위</th>
		        	<th width="17%">전화번호</th>
		        	<th width="13%">휴대폰번호</th>
		        	<th width="26%">E-MAIL</th>
		        </tr>
		        <%
        		  	for(int i = 0 ; i < mgr_size ; i++){
        				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);        		
        				
        				if(mgr.getMgr_st().equals("차량이용자") || mgr.getMgr_st().equals("차량관리자") || mgr.getMgr_st().equals("회계관리자")){
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
		<td colspan="2"><span class=style2>2. 대여이용 기본사항</span></td>
	</tr>
	<tr>
		<td colspan="2" class="doc">
			<table class="center">
				<tr>
					<th rowspan="2" width="5%">대<br>여<br>차<br>량</th>
					<th width="18%">차종</th>
					<th width="40%">선택사양</th>
					<th width="15%">색상</th>
					<th width="17%">차량가격<br><span class="fs">-제조사 소비자가격-</span></th>
					<th width="5%">대수</th>
				</tr>
				<tr>
					<td>&nbsp;<%=cm_bean.getCar_nm()%>&nbsp;<%=cm_bean.getCar_name()%></td>
					<td>&nbsp;<%=car.getOpt()%></td>
					<td>&nbsp;<%=car.getColo()%> 
						<%if(!car.getIn_col().equals("")){%>
						&nbsp;
					  	(내장:<%=car.getIn_col()%>)  
						<%}%>
						<%if(!car.getGarnish_col().equals("")){%>
						&nbsp;
					  	(가니쉬:<%=car.getGarnish_col()%>)  
						<%}%>
					</td>
					<td>&nbsp;<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt())%>원					    
					    <%if(!base.getCar_gu().equals("1") || !rent_st.equals("1")){ //연장,재리스%>
					    <br>
					    <%		if(fee_opt_amt>0){%>
					    &nbsp;(<%=AddUtil.parseDecimal(fee_opt_amt)%>원)
					    <%		}else{%>
					    &nbsp;(<%=AddUtil.parseDecimal(fee_etc.getSh_amt())%>원)
					    <%		}%>
					    <%}else{%>
					    <%	if(car.getTax_dc_s_amt() > 0){%>
					    	<br>&nbsp;(개소세 감면후)
					    <%	}%>
					    <%	if(cont_etc.getView_car_dc() > 0){%>
					    	<br>(<%=AddUtil.parseDecimal(cont_etc.getView_car_dc())%>원)
					    <%	}%>
					    <%}%>
					</td>
					<td>1대</td>
				</tr>
				<tr>
					<th>이용<br>기간</th>
					<td colspan="5"><input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getCon_mon().equals("12"))%>checked<%%>>12개월 
					    &nbsp;&nbsp;<input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getCon_mon().equals("24"))%>checked<%%>>24개월 
					    &nbsp;&nbsp;<input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getCon_mon().equals("36"))%>checked<%%>>36개월 
					    &nbsp;&nbsp;<input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getCon_mon().equals("48"))%>checked<%%>>48개월 
					    &nbsp;&nbsp;<input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getCon_mon().equals("12")||fee.getCon_mon().equals("24")||fee.getCon_mon().equals("36")||fee.getCon_mon().equals("48")){%><%}else{%>checked<%}%>>기타( <%if(fee.getCon_mon().equals("12")||fee.getCon_mon().equals("24")||fee.getCon_mon().equals("36")||fee.getCon_mon().equals("48")){%>&nbsp;&nbsp;&nbsp;<%}else{%><%=fee.getCon_mon()%><%}%>)개월<br>
					    <%if(fee.getRent_start_dt().equals("")){%>
					    20 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;년 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;월 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;일부터 &nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp; 20 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;년 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;월 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;일까지
					    <%}else{%>
					    <%=AddUtil.getDate3(fee.getRent_start_dt())%>부터 ~ <%=AddUtil.getDate3(fee.getRent_end_dt())%>까지
					    <%}%>
					</td>
				</tr>
			</table>
			<table class="center">
				<tr>
					<th rowspan="6" width="5%">보험사항</th>
					<th width="20%">운전자범위</th>
					<th width="13%">운전자연령</th>
					<th colspan="3">보험가입금액 (보상한도)</th>
				</tr>
				<tr>
					<td rowspan="4" class="left"><input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getCom_emp_yn().equals("Y")){%> checked <%}%>>계약자의 임직원<br><span class="fs">(임직원 한정운전 특약 가입)</span><br><br>
					<input type="checkbox" name="checkbox" value="checkbox" <%if(!cont_etc.getCom_emp_yn().equals("Y")){%> checked <%}%>>계약자<br> &nbsp;&nbsp;&nbsp;&nbsp; 계약자의 임직원/가족<br> &nbsp;&nbsp;&nbsp;&nbsp; 계약자 임직원의 가족</td>
					<td rowspan="4" class="left">
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getDriving_age().equals("0")){%> checked <%}%>>만26세 이상<br>
				    <%if(base.getCar_st().equals("3")){ //리스 %>
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getDriving_age().equals("3")){%> checked <%}%>>만24세 이상<br>
				    <%} %>
					    <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getDriving_age().equals("1")){%> checked <%}%>>만21세 이상</td>
					<td width="11%">대 인 배 상</td>
					<td width="26%">무한(대인배상 Ⅰ,Ⅱ)</td>
					<td rowspan="4" width="25%" class="left style8">
						※ 자기차량손해 면책금(자기부담금)<br>
						<table border="1" style="width: 90%; margin-left: 9px;">
							<tr>
								<td class="center" width="30%">사고건당</td>
								<td width="70%">
									<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_ja()==300000){%> checked <%}%>> 30만원 <br> 
					    			<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_ja() > 300000 || base.getCar_ja() < 300000){%> checked <%}%>> 기타(<%if(base.getCar_ja() > 300000 || base.getCar_ja() < 300000){%><%=base.getCar_ja()/10000%><%}else{%>&nbsp;<%}%>)만원
								</td>
							</tr>
						</table>
						<span class="fs">(별도의 당사 차량손해면책제도에 의거 보상-좌측의 종합보험 가입 보험사 약관에 준함)</span>
					</td>
				</tr>
				<tr>
					<td>대 물 배 상</td>
					<td class="left"><!--<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getGcp_kd().equals("1")){%> checked <%}%>>5천만원-->
						<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getGcp_kd().equals("2")){%> checked <%}%>>1억원
						<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getGcp_kd().equals("4")){%> checked <%}%>>2억원
						<input type="checkbox" name="checkbox" value="checkbox" <%if(!base.getGcp_kd().equals("2")&&!base.getGcp_kd().equals("4")){%> checked <%}%>>기타
						(<%if(base.getGcp_kd().equals("1")){%>5천만<%}else if(base.getGcp_kd().equals("8")){%>3억<%}else if(base.getGcp_kd().equals("3")){%>5억<%}%>)원
					</td>
				</tr>
				<tr>
					<td>자기신체사고</td>
					<td class="left"><!--<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getBacdt_kd().equals("1")){%> checked <%}%>>5천만원-->
						<input type="checkbox" name="checkbox" value="checkbox" <%if(base.getBacdt_kd().equals("2")){%> checked <%}%>>1억원
					</td>
				</tr>		
				<tr> 
					<td>무보험차상해</td>
					<td class="left">
						<input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getCanoisr_yn().equals("Y")){%> checked <%}%>>가입 <span class="fs">(피보험자 1인당 최고2억원)</span>
						<input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getCanoisr_yn().equals("N")){%> checked <%}%>>미가입						
					</td>
				</tr>	
				<tr>
					<td colspan="5" class="left">* 여기서 가족이란 부모, 배우자, 배우자의 부모, 자녀, 며느리, 사위를 말합니다. (형제·자매는 포함되지 않습니다)<br>
					<%-- <%if(base.getCar_st().equals("3")){	//리스 %>
						* 긴급출동 : 마스타자동차관리 1588-6688
					<%}else{ 	//렌트%> --%>
						* 긴급출동 : 1588-6688, 1670-5494
					<%-- <%} %> --%>
					</td>
				</tr>
			</table>
			<table class="center" style="font-size: 10px;">
				<tr>
					<td width="13%" rowspan="4">차량관리 서비스<br>제공범위<br>(체크된 □칸의 서비스가 제공됩니다)</td>
					<td width="18%">공통서비스</td>
					<td colspan="3">
						<%-- <input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getPro_yn().equals("Y")){%>checked<%}%>>교통사고 발생시 사고처리 업무 대행
						<input type="checkbox" name="checkbox" value="checkbox" <%if(cont_etc.getAc_dae_yn().equals("Y")){%>checked<%}%>>사고대차서비스(단, 피해사고시는 보험대차) --%>
						* 교통사고 발생시 사고처리 업무 대행
						* 사고대차서비스(단, 피해사고시는 보험대차)[도서지역 제외]
					</td>
				</tr>	
				<tr>
					<td colspan="2" width="43%">
						<input type="checkbox" name="checkbox" value="checkbox" <%if(!fee.getRent_way().equals("1")){%>checked<%}%>>기본식(정비서비스 미포함 상품)
					</td>
					<td colspan="2" width="42%">
						<input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getRent_way().equals("1")){%>checked<%}%>>일반식(정비서비스 포함 상품)
					</td>
				</tr>
				<tr>
					<td colspan="2" class="left">
						&nbsp;* 아마존케어 서비스<br>
						&nbsp;&nbsp;- 차량 정비 관련 유선 상담 서비스 상시 제공<br>
						&nbsp;&nbsp;- 대여 개시 2개월 이내 무상 정비대차 제공 (테슬라차량 제외)<br>
						&nbsp;&nbsp;&nbsp; (24시간 이상 정비공장 입고시)<br>
						&nbsp;&nbsp;- 대여 개시 2개월 이후 원가 수준의 유상 정비대차 제공<br>
						&nbsp;&nbsp;&nbsp; (단기 대여요금의 15~30% 수준, 탁송료 별도<br>
					</td>
					<td colspan="2" class="left">
						&nbsp;* 일체의 정비서비스<br>
						&nbsp;&nbsp;- 각종 내구성부품/소모품 점검, 교환, 수리<br>
						&nbsp;&nbsp;- 제조사 차량 취급설명서 기준<br>
						&nbsp;&nbsp;※ 지정 정비업체에 고객이 입고하여 정비<br>
						&nbsp;* 정비대차서비스<br>
						&nbsp;&nbsp;- 4시간 이상 정비공장 입고시<br>
					</td>
				</tr>
				<tr>
					<td class="left" colspan="4">						
					<%if(base.getCar_st().equals("3")){	//리스 %>
						&nbsp;* 친환경차는 일반 내연기관 차량으로, 수입차는 국산차로 대차서비스하며 승합차종이나 화물차종은 승용 및 RV로 대차서비스합니다.
					<%}else{ 	//렌트%>
						&nbsp;* 친환경차는 일반 내연기관 차량으로, 수입차는 국산차로 대차서비스하며, 승합차종은 승용 및 RV로 대차서비스합니다.
					<%} %>
						<br>
						&nbsp;* 사고발생시 임차인의 임의적인 사고수리는 인정되지 않습니다.<br>&nbsp;&nbsp; - 사고로 인한 차량수리가 필요한 경우에는 (주)아마존카의 확인 및 선조치 사항이 있어야 (주)아마존카에서<br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 수리비가 지불됩니다.</td>
				</tr>	
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2"><span class=style2>3. 대 여 요 금</span></td>
	</tr>
	<tr>
		<td colspan="2" class="doc">
			<table class="right">
				<tr>
					<th width=10%>구분</th>
					<th width=15%>보증금</th>
					<th width=15%>선납금</th>
					<th width=15%>개시대여료</th>
					<th width=15%>월대여료</th>
					<th width=15%>월대여료<br>납입할 횟수</th>
					<th width=15%>월대여료<br>납입할 날짜</th>
				</tr>
				<tr>
					<th>공급가</th>
					<td><%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>원</td>
					<td><%=AddUtil.parseDecimal(fee.getPp_s_amt())%>원</td>
					<td><%=AddUtil.parseDecimal(fee.getIfee_s_amt())%>원</td>
					<td><%=AddUtil.parseDecimal(fee.getFee_s_amt())%>원</td>
					<td rowspan="3" class="center"><%=fee.getFee_pay_tm()%>&nbsp;회</td>
					<td rowspan="3" class="center">매월 
					    <%if(fee.getFee_est_day().equals("99")){%> &nbsp;말일 
					    <%}else if(fee.getFee_est_day().equals("98")){%> &nbsp;대여개시일 
					    <%}else{%>
					    &nbsp;&nbsp;<%=fee.getFee_est_day()%>&nbsp;일
					    <%}%>					
					</td>
				</tr>
				<tr>
					<th>부가세</th>
					<td class="center">-</td>
					<td><%=AddUtil.parseDecimal(fee.getPp_v_amt())%>원</td>
					<td><%=AddUtil.parseDecimal(fee.getIfee_v_amt())%>원</td>
					<td><%=AddUtil.parseDecimal(fee.getFee_v_amt())%>원</td>
				</tr>
				<tr>
					<th>합 계</th>
					<td><%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>원</td>
					<td><%=AddUtil.parseDecimal(fee.getPp_s_amt()+fee.getPp_v_amt())%>원</td>
					<td><%=AddUtil.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%>원</td>
					<td><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>원</td>
				</tr>
				<tr>
					<th rowspan="2">비고</th>
					<td colspan="3" class="center">초기 납입금 합계: &nbsp;&nbsp;<%=AddUtil.parseDecimal(fee.getGrt_amt_s()+fee.getPp_s_amt()+fee.getPp_v_amt()+fee.getIfee_s_amt()+fee.getIfee_v_amt())%>원</td>
					<td colspan="3" class="right">※ 상기 월대여료는 자동이체 출금(CMS) 기준 금액입니다.<br>※ 마지막 회차 결제일은 계약 만료일입니다.</td>
				</tr>
				<tr>
					<td colspan="6" class="left">
						&nbsp;※ 선납금 납부시 세금계산서 발행 방식 : 
						<input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getPp_chk().equals("0")){%>checked<%}%>>매월 균등 발행 
						<input type="checkbox" name="checkbox" value="checkbox" <%if(fee.getPp_chk().equals("1")){%>checked<%}%>>일시발행
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2" class="fss">&nbsp;&nbsp;&nbsp;* 1. 보증금은 계약기간 만료후 고객님께 환불해 드립니다.<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2. 선납금은 이용기간동안 매월 일정 금액씩 공제되며, 계약 만료후 환불되는 돈이 아닙니다.<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3. 개시대여료는 마지막 ( &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;)개월치 대여료를 선납하는 것입니다.<br>
			<%//if(base.getCar_gu().equals("1") && fee.getRent_st().equals("1")){%>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4. 초기 납입금 (보증금, 선납금, 개시대여료)은 신차출고 2일전까지는 (주)아마존카로 입금되어야 합니다.<br>
			<%//}%>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5. 차량가 변동 또는 정부의 조세 정책이 변경될 경우 본 계약의 월대여료 및 매입옵션가격이 변경될 수 있습니다.
		</td>
	</tr>
	<tr>
		<td colspan="2" class="right fss">( 계약번호 : <%=rent_l_cd%>, Page 1/2, <%=AddUtil.ChangeDate2(fee.getRent_dt())%> )</td>
	</tr>	