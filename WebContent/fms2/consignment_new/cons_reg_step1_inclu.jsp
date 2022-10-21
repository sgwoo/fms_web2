<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<% 
 	int cons_cau_7 = 0;
	int cons_cau_10 = 0;
	for(int j=0; j<2; j++){
	
		cost_st = "";
		pay_st 	= "";
		
		if(j==0){
			display = "''";
			if(!car_mng_id.equals("") && j==0){
				car = car1;
				if(rent_st.equals("1")) 		cons_cau = "1";
				else if(rent_st.equals("2")) 	cons_cau = "4";
				else if(rent_st.equals("3")) 	cons_cau = "5";
				else if(rent_st.equals("9")) 	cons_cau = "1";
				else if(rent_st.equals("10")) 	cons_cau = "3";
				else if(rent_st.equals("6")) 	cons_cau = "19";
				else if(rent_st.equals("8")) 	cons_cau = "19";
				else if(rent_st.equals("12")) 	cons_cau = "1";
				
				cost_st = "1";
				pay_st	= "2";
			}
		}else{
			if(!sub_l_cd.equals("") && j==1){
			 	car = car2;
				display = "''";
				if(rent_st.equals("2")) 	cons_cau = "11";
				else if(rent_st.equals("3")) 	cons_cau = "12";
				
				cost_st = "1";
				pay_st	= "2";
			}else{
				car = new Hashtable();
				display = "none";
				cons_cau = "";
			}
		}
		if(cons_cau.equals("7")){	cons_cau_7 ++;	}
		if(cons_cau.equals("10")){	cons_cau_10 ++;	}
		%>
	<tr id=tr_cons<%=j%>_1 style="display:<%=display%>">
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>탁송<%=j+1%></span>
		
		</td>
	</tr>
    <tr id=tr_cons<%=j%>_2 style="display:<%=display%>"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr><td class=line2 style='height:1'></td></tr>
				<%	
					
				%>
                <tr> 
                    <td width='13%' class='title'>차량번호/차대번호</td>
                    <td width='37%'>&nbsp;
        			  <input type='text' name="car_no" value='<%=car.get("CAR_NO")==null?"":car.get("CAR_NO")%>' size='25' class='text' onKeyDown="javasript:enter('car_no', <%=j%>)" style="IME-MODE:active;">
        			  <input type='hidden' name='car_mng_id' id="car_mng_id_<%=j%>" value='<%=car.get("CAR_MNG_ID")==null?"":car.get("CAR_MNG_ID")%>'>
        			  <input type='hidden' name='rent_mng_id' value='<%=car.get("RENT_MNG_ID")==null?"":car.get("RENT_MNG_ID")%>'>
        			  <input type='hidden' name='rent_l_cd' id="rent_l_cd_<%=j%>" value='<%=car.get("RENT_L_CD")==null?"":car.get("RENT_L_CD")%>'>
        			  <input type='hidden' name='client_id' value='<%=car.get("CLIENT_ID")==null?"":car.get("CLIENT_ID")%>'>
        			    <span class="b"><a href="javascript:search_car(<%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
						&nbsp;&nbsp;&nbsp;		
						<span class="b"><a href="javascript:search_car_res(<%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요">[배/반차 차량 조회]</a></span>
        			</td>
        			<td width='13%' class='title'>차명</td>
        			<td width='37%'>&nbsp;
        			  <input type='text' name="car_nm" value='<%=car.get("CAR_NM")==null?"":car.get("CAR_NM")%> <%=car.get("CAR_NAME")==null?"":car.get("CAR_NAME")%>' size='40' class='whitetext' readonly>
        			  <span class="b"><a href="javascript:view_car(<%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_see.gif"  border="0" align=absmiddle></a></span>
        			  </td>
                </tr>
    		    <tr>
        		    <td class='title'>연식</td>
        			<td>&nbsp;
        			  <input type='text' name="car_y_form" value='<%=car.get("CAR_Y_FORM")==null?"":car.get("CAR_Y_FORM")%>' size='40' class='whitetext' readonly>
        			</td>
        		    <td class='title'>색상</td>
        			<td>&nbsp;
        			  <input type='text' name="color" value='<%=car.get("COLO")==null?"":car.get("COLO")%>' size='40' class='whitetext' readonly></td>			
    		    </tr>
    		    
    		    <tr>
        		    <td class='title'>기본사양</td>
        			<td colspan="3" >&nbsp;
        			  <textarea rows='5' cols='100' name='car_b' readonly><%=car.get("CAR_B")==null?"":car.get("CAR_B")%></textarea>        			  
        			</td>
    		    </tr>    	
    		    <tr>
        		    <td class='title'>선택사양</td>
        			<td colspan="3" >&nbsp;
        			  <input type='text' name="opt" value='<%=car.get("OPT")==null?"":car.get("OPT")%>' size='100' class='whitetext' readonly>
        			</td>
    		    </tr>    	    		   
    		    
    		    <tr>
        		    <td class='title'>고객명</td>
        			<td>&nbsp;
        			  <input type='text' name="firm_nm" value='<%=car.get("FIRM_NM")==null?"":car.get("FIRM_NM")%>' size='60' class='whitetext' readonly>
        			</td>
        		    <td class='title'>하이패스여부</td>
        			<td>&nbsp;
        				<input type='text' name="r_hipass_yn" value='<%=car.get("HIPASS_YN")==null?"":car.get("HIPASS_YN")%>' size='10' class='whitetext' readonly>
          			</td>	
        				  <!--
        		    <td class='title'>신차여부</td>
        			<td>&nbsp;
        				<input type='hidden' name="car_gu" value='<%=car.get("CAR_GU")==null?"":car.get("CAR_GU")%>' id="cargu" size='40' class='whitetext'>
        				<input type='hidden' name="shin_car" value='<%=car.get("SHIN_CAR")==null?"":car.get("SHIN_CAR")%>' id="shincar" size='40' class='whitetext'  >
          			</td>
          			-->
    		    </tr>
		    </table>
	    </td>
    </tr>
	<%if(j==0){%>
	<tr id=tr_cons<%=j%>_3 style="display:<%=display%>">
	    <td align="right">&nbsp;
			  <span class="b"><a href="javascript:view_car_sh(<%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_dgir.gif"  border="0" align=absmiddle></a></span>&nbsp;
			  <span class="b"><a href="javascript:view_car_lh(<%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_jgir.gif"  border="0" align=absmiddle></a></span>
			  <input type='hidden' name='cons_copy' value=''>	  
	    </td>
	</tr>	
	<%}else{%>
	<tr id=tr_cons<%=j%>_3 style="display:<%=display%>">
	    <td align="right">
	    &nbsp;<input type='text' name="cons_copy" value='' size='2' class='text'>번 탁송 <a href="javascript:value_copy(<%=j%>)">내용복사</a>
		&nbsp;/<a href="javascript:value_copy2(<%=j%>)">왕복</a>
	    </td>
	</tr>	
	<%}%>
	<tr>
	    <td class=h></td>
	</tr>
    <tr id=tr_cons<%=j%>_4 style="display:<%=display%>"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr><td class=line2 style='height:1'></td></tr>
    		    <tr>
        		    <td colspan="2" class='title'>의뢰자</td>
        		    <td >&nbsp;
        			  <select name='req_id'>
                        <option value="">선택</option>
                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}%>
                      </select>
        			</td>
        		    <td colspan="2" class='title'>탁송구간</td>
        		    <td>&nbsp;        		    
        		    <!-- 전국인 경우 필수선택 : 요금 setting -->
        			  <select name="cmp_app">
        			        <option value=''>탁송구간을 선택하세요</option>
        			     </td>
        		
    	        </tr>				
    		    <tr>
        		    <td colspan="2" class='title'>탁송사유</td>
        		    <td colspan="4">&nbsp;
        			  <select name="cons_cau" id="cons_cau<%=j%>" onChange="javascript:cng_input4(this.value, <%=j%>)">
        			    <option value="">선택</option>
        				<%for(int i = 0 ; i < c_size ; i++){
        					CodeBean code = codes[i];	%>
        				<option value='<%=code.getNm_cd()%>' <%if(cons_cau.equals(code.getNm_cd()))%>selected<%%>><%= code.getNm()%></option>
        				<%}%>
          			  </select>
        			  &nbsp;기타사유 : <input type='text' name="cons_cau_etc" value='' size='40' class='text'>
        			  &nbsp;<font color="#666666">(한글 25자 이내)</font>
        			  <input type="button" id="search" name="search" onclick="" value="원계약 조회" style="display:none">
        			  <span id="car_no_text" name="car_no_text" style="display:none">원계약 차량 번호</span> 
        			  <input type="text" id="sub_car_no" name="sub_car_no" class="text" value="" style="display:none" onclick="test()" readonly>
        			  <input type="text" id="sub_rent_l_cd" name="sub_rent_l_cd" class="sub_rent_l_cd" style="display:none">
        			  <input type="text" id="age_scp" name="age_scp" class="age_scp" style="display:none">
        			</td>
    	        </tr>
    		    <tr>
        		    <td colspan="2" class='title'>비용구분</td>
        			<td>&nbsp;
        			  <select name="cost_st">
        			    <option value="">선택</option>
        			    <option value="1" <%if(cost_st.equals("1"))%>selected<%%>>아마존카</option>
        			    <option value="2" <%if(cost_st.equals("2"))%>selected<%%>>고객</option>								
          			  </select>
        			  &nbsp;<font color=red>[고객부담]탁송료 : <input type='text' name="cust_amt" value='0' size='7' class='rednum' onBlur='javascript:this.value=parseDecimal(this.value);'>원</font>
        			</td>						
        		    <td colspan="2" class='title'>지급구분</td>
        			<td>&nbsp;
        			  <select name="pay_st">
        			    <option value="">선택</option>
        			    <option value="1" <%if(pay_st.equals("1"))%>selected<%%>>선불</option>
        			    <option value="2" <%if(pay_st.equals("2"))%>selected<%%>>후불</option>								
          			  </select>
        			</td>						
    	        </tr>
    		    <tr>
        		    <td rowspan="4" class='title'>요<br>
        	        청</td>
        		    <td class='title'>세차</td>
        		    <td colspan="4">&nbsp;
        			  <select name="wash_yn">
        			    <!-- <option value="Y">요청</option> -->
        			    <option value="M">기계세차</option>
        			    <option value="H">손세차</option>
        			    <option value="N" selected>없음</option>								
          			  </select>
        			</td>
    	        </tr>
    		    <tr>
        		    <td class='title'>주유</td>
        		    <td colspan="4">&nbsp;
        			  <select name="oil_yn">
        			    <option value="Y">요청</option>
        			    <option value="N" selected>없음</option>								
          			  </select>
        				주유요청시 -&gt; 
        			  <input type='text' name="oil_liter" value='' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
        				리터<!--ℓ--> 
        				혹은
        			  <input type='text' name="oil_est_amt" value='' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
        				원어치 주유 해주세요.</td>
    	        </tr>
    		    <tr>
        		    <td class='title'>하이패스등록</td>
        		    <td colspan="4">&nbsp;
        			  <select name="hipass_yn">
        			    <option value="Y">요청</option>
        			    <option value="N" selected>없음</option>								
          			  </select>
					  (등록대행 의뢰시 선택하십시오.)
        			</td>
    	        </tr>				
    		    <tr>
    		      <input type='hidden' name="other"  > 
        		    <td class='title'>기타</td>
        		    <td colspan="4">&nbsp;
                      <textarea rows='5' cols='90' name='etc' style="color:red"></textarea></td>
    	        </tr>		  
    		    <tr>
        		    <td width="3%" rowspan="6" class='title'>출<br>발</td>
        		    <td width="10%" class='title'>구분</td>
        		    <td width="37%">&nbsp;
        			  <select name="from_st" id="from_st" style="width:150px;" onChange="javascript:cng_input3('from', this.value, <%=j%>)">
        			    <option value="">선택</option>
        			    <option value="1">아마존카</option>
        			    <option value="2">고객</option>
        			    <option value="3">협력업체</option>
        			    <option value="4">신차출발</option>				
          			  </select>		
        			  <span class="b"><a href="javascript:cng_input3('from', document.form1.from_st[<%=j%>].options[document.form1.from_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			</td>
        		    <td width="3%" rowspan="6" class='title'>도<br>착</td>
        		    <td width="10%" class='title'>구분</td>
        		    <td width="37%">&nbsp;
        			  <select name="to_st" style="width:150px;" onChange="javascript:cng_input3('to', this.value, <%=j%>)">
        			    <option value="">선택</option>
        			    <option value="1">아마존카</option>
        			    <option value="2">고객</option>
        			    <option value="3">협력업체</option>				
          			  </select>			
        			  <span class="b"><a href="javascript:cng_input3('to', document.form1.to_st[<%=j%>].options[document.form1.to_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			</td>			
    		    </tr>
    		    <tr>
        		    <td width="10%" class='title'>장소</td>
        		    <td>&nbsp;
                        <input type='text' name="from_place" id="from_place" value='' size='40' class='text' ></td>
        		    <td width="10%" class='title'>장소</td>
        		    <td>&nbsp;
                        <input type='text' name="to_place" value='' size='40' class='text' ></td>
    		    </tr>
    		    <tr>
        		    <td class='title'>상호/성명</td>
        		    <td>&nbsp;
                        <input type='text' name="from_comp" id="from_comp" value='' size='40' class='text' >
        				</td>
        		    <td class='title'>상호/성명</td>
        		    <td>&nbsp;
                        <input type='text' name="to_comp" value='' size='40' class='text' ></td>
    		    </tr>
    		    <tr>
        		    <td class='title'>담당자</td>
        	        <td>&nbsp;부서/직위
        	          <input type='text' name="from_title" id="from_title" value='' size='20' class='text' ><br>
                      &nbsp;성명&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <input type='text' name="from_man" id="from_man" value='' size='20' class='text' >
        			  <span class="b"><a href="javascript:cng_input5('from', document.form1.from_st[<%=j%>].options[document.form1.from_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			</td>
        		    <td class='title'>담당자</td>
        		    <td>&nbsp;부서/직위
        		      <input type='text' name="to_title" value='' size='20' class='text' ><br>
        			  &nbsp;성명&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        			  <input type='text' name="to_man" value='' size='20' class='text' >
        			  <span class="b"><a href="javascript:cng_input5('to', document.form1.to_st[<%=j%>].options[document.form1.to_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			</td>
    		    </tr>
    		    <tr>
        		    <td class='title'>연락처</td>
        		    <td>&nbsp;사무실
                        <input type='text' name="from_tel" id="from_tel" value='' size='15' class='text' ><br>
        				&nbsp;핸드폰
                        <input type='text' name="from_m_tel" id="from_m_tel" value='' size='15' class='text' >
        			</td>
        		    <td class='title'>연락처</td>
        		    <td>&nbsp;사무실
                        <input type='text' name="to_tel" value='' size='15' class='text' ><br>
        				&nbsp;핸드폰
                        <input type='text' name="to_m_tel" value='' size='15' class='text' >
        			</td>
    		    </tr>
    		    <tr>
        		    <td class='title'>요청일시</td>
        		    <td>&nbsp;
                      <input type='text' name="from_req_dt" value='<%=AddUtil.getDate()%>' size='11' class='text' onBlur='javascript:this.value=ChangeDate(this.value); document.form1.to_req_dt[<%=j%>].value=this.value;'>
                      &nbsp;
        			  <select name="from_req_h" onchange="javascript:document.form1.to_req_h[<%=j%>].value=this.value;">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="from_req_s" onchange="javascript:document.form1.to_req_s[<%=j%>].value=this.value;">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                    </td>
        		    <td class='title'>요청일시</td>
        		    <td>&nbsp;
                      <input type='text' name="to_req_dt" value='<%=AddUtil.getDate()%>' size='11' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                      &nbsp;
        			  <select name="to_req_h">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="to_req_s">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                    </td>
    	        </tr>
    		    <tr>
        		    <td colspan="2" class='title'>운전자명</td>
                    <td>&nbsp;
                        <input type='text' name="driver_nm" value='' size='15' class='text' >
        				<input type='hidden' name="driver_id" value=''>
        				<span class="b"><a href="javascript:cng_input6('driver','3',<%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif" align="absbottom" border="0"></a></span>
        			</td>
                    <td colspan="2" class='title'>운전자핸드폰</td>
                    <td>&nbsp;
                        <input type='text' name="driver_m_tel" value='' size='15' class='text' ></td>
    	        </tr>
				
            </table>
        </td>
    </tr>
<!--
	<tr id=tr_cons<%=j%>_5 style="display:<%=display%>">
	    <td>&nbsp;</td>
	</tr>		
-->	
<%}%>
<!-- 탁송사유:사고대차회수 > 채권양도 통지서 폼 on -->
	<input type="hidden" name="ac_accid_id" value="" />
	<input type="hidden" name="ac_rent_mng_id" value="" />
	<input type="hidden" name="ac_rent_l_cd" value="" />
	<input type="hidden" name="ins_com_id" value="" />
	<input type="hidden" name="ac_client_id" value="" />
	<input type="hidden" name="ac_client_st" value="" />
	<input type="hidden" name="ac_client_nm" value="" />
	<input type="hidden" name="ac_firm_nm" value="" />
	<input type="hidden" name="ac_birth" value="" />
	<input type="hidden" name="ac_enp_no" value="" />
	<input type="hidden" name="ac_zip" value="" />
	<input type="hidden" name="ac_addr" value="" />
	
	<input type="hidden" name="ac_car_mng_id" value="" />
	<input type="hidden" name="ac_car_st" value="" />
	<input type="hidden" name="ac_car_no" value="" />
	<input type="hidden" name="ac_car_nm" value="" />
	<input type="hidden" name="ac_ins_req_gu" value="2" /><!-- 2:대차료 -->
	<input type="hidden" name="ins_day_amt" value="" />
	<input type='hidden' name='ac_ot_fault_per' value='100'>
	<input type="hidden" name="bond_trf_yn" id="bond_trf_yn" value="N" />
	
	<input type="hidden" name="sch_ac_c_id" value="" />
	<input type="hidden" name="sch_ac_car_no" value="" />
	
    <tr class='bondForm' style="display:<%if(cons_cau_10 > 0){ %>''<%}else{%>none<%}%>;">
	    <td class=h></td>
	</tr>
    <tr class='bondForm' style="display:<%if(cons_cau_10 > 0){ %>''<%}else{%>none<%}%>;">
		<td>
			<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>채권양도 통지서 및 위임장</span>
			<!-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="checkbox" name="bond_trf_chk" checked> 채권양도 통지서 및 위임장을 생성합니다.<br> -->
			<div style="padding-top:5px; padding-bottom:5px;">※ 사고대차회수 탁송은 채권양도통지서 및 위임장도 함께 생성합니다(사고등록필수). 사고등록여부 확인 후 탁송의뢰해주세요.</div>
			<div style="padding-top:5px; padding-bottom:5px;">※ 하단에 입력한 정보는 오직 채권양도 통지서 문서 생성을 위해서만 사용될뿐 사고등록과 연동되지않습니다. 정확한 정보는 사고조회에서 추가입력해주세요.</div>
		</td>
    </tr>
    <tr class='bondForm' style="display:<%if(cons_cau_10 > 0){ %>''<%}else{%>none<%}%>;"> 
        <td class='line' width="100%"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr><td class=line2 style='height:1'></td></tr>
    			<tr>
    				<td class='title' width="15%">대차/사고/탁송조회</td>
    				<td  width="85%">&nbsp;
    					<span class="b"><a href="javascript:search_total();" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
    				</td>
    			</tr>
    			<tr>
    				<td class='title'>사고일자</td>
    				<td>&nbsp;<input type="text" name="accid_dt" class="text" value=""/></td>
    			</tr>
    			<tr>
    				<td class='title'>수신처(보험사/상호)</td>
    				<td>&nbsp;<input type="text" name="ins_com_nm" class="text"/>
    					&nbsp;&nbsp;&nbsp;※ 사고유형-쌍방/피해/가해 건은 상대보험사, 단독 건은 고객상호를 입력 </td>
    			</tr>
    			<tr>
    				<td class='title'>수리기간</td>
    				<td>&nbsp;
    					<input type="text" name="ins_use_st" value="<%-- <%=AddUtil.ChangeDate2(i_start_dt)%> --%>" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);' maxlength="10">

					  <select name="use_st_h">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%-- <%if(i_start_h.equals(AddUtil.addZero2(i))){%>selected<%}%> --%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="use_st_s">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%-- <%if(i_start_s.equals(AddUtil.addZero2(i))){%>selected<%}%> --%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>	

                      ~ 
                      <input type="text" name="ins_use_et" value="<%-- <%=AddUtil.ChangeDate2(i_end_dt)%> --%>" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value); set_ins_use_dt();' maxlength="10">

					  <select name="use_et_h" onChange="javscript:set_ins_use_dt();">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%-- <%if(i_end_h.equals(AddUtil.addZero2(i))){%>selected<%}%> --%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="use_et_s" onChange="javscript:set_ins_use_dt();">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%-- <%if(i_end_s.equals(AddUtil.addZero2(i))){%>selected<%}%> --%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>	

                      ( 
                      <input type="text" name="ins_use_day" value="<%-- <%=ma_bean.getIns_use_day()%> --%>" size="3" class=num onBlur='javscript:set_ins_amt();'>
                      일					  
					  <input type="text" name="use_hour" value="<%-- <%=ma_bean.getUse_hour()%> --%>" size="2" class=num onBlur='javscript:set_ins_amt();'>
                      시간 	
					  )
        			  &nbsp;&nbsp;<span class="b"><a href="javascript:set_reqamt('')" onMouseOver="window.status=''; return true" title="계산하기"><img src="/acar/images/center/button_in_cal.gif" align="absmiddle" border="0"></a></span>
        			  <span class="b"><a href="javascript:set_reqamt('view')" onMouseOver="window.status=''; return true" title="계산식 보기"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a></span>
    				</td>
    			</tr>
    			<tr>
    				<td class='title'>대차료</td>
    				<td>&nbsp;<input type="text" name="ins_req_amt" class="text"/>원 
    					<br>&nbsp;(대차료[청구금액]=((1일청구기준*대차일수)+(1일청구기준/24*대차시간))*상대과실율)
    					
    				</td>
    			</tr>
    		</table>
    	</td>
    </tr>