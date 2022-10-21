<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%//탁송의뢰 1번
	
         int jj =0;
	//차량관리담당자 가져 올라고 
//	ContBaseBean 	base	= a_db.getCont(b_cons.getRent_mng_id(), b_cons.getRent_l_cd());

	Vector  codes2 = new Vector();
	int c_size2 = 0;	
	
	 if (b_cons.getOff_id().equals("002740")||b_cons.getOff_id().equals("009217") ){
		codes2 = c_db.getCodeAllV_0022_New("0022");	
		c_size2 = codes2.size();
	} else	if ( off_id.equals("010255")  ) {
		codes2 = c_db.getCodeAllV_0022_w("0022");	
		c_size2 = codes2.size();		
	} else {
	//	codes2 = c_db.getCodeAllV_0022("0022");	
		codes2 = c_db.getCodeAllV_0022_NNew("0022");	//아마존탁송코드 제외
		c_size2= codes2.size();
	}	 
%>
        
	<%for(int j=b_cons.getCons_su(); j > 0; j--){	
	
		//탁송의뢰 1번
		ConsignmentBean cons 		= cs_db.getConsignment(cons_no, j);
		CarRegBean 	car_2 		= crd.getCarRegBean(cons.getCar_mng_id());
		ContCarBean 	car_etc 	= a_db.getContCarNew(cons.getRent_mng_id(), cons.getRent_l_cd());
		ClientBean 	client 		= al_db.getNewClient(cons.getClient_id());
		CarMstBean 	cm_bean 	= cmb.getCarNmCase(String.valueOf(car_etc.getCar_id()), String.valueOf(car_etc.getCar_seq()));
		
		ContBaseBean 	base	= a_db.getCont(cons.getRent_mng_id(), cons.getRent_l_cd());
	%>
	<tr id=tr_cons<%=jj%>_1 style="display:''">
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>탁송<%=jj+1%></span></td>
	</tr>
    <tr id=tr_cons<%=jj%>_2 style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr><td class=line2 style='height:1'></td></tr>
                <tr> 
                    <td width='13%' class='title'>차량번호</td>
                    <td width='37%'>&nbsp;
        			  <input type='text' name="car_no" value='<%=cons.getCar_no()%>' size='30' class='whitetext' readonly>
        			  <input type='hidden' name='seq' value='<%=cons.getSeq()%>'>
        			  <input type='hidden' name='car_mng_id' id="car_mng_id_<%=jj%>" value='<%=cons.getCar_mng_id()%>'>
        			  <input type='hidden' name='rent_mng_id' value='<%=cons.getRent_mng_id()%>'>
        			  <input type='hidden' name='rent_l_cd' id="rent_l_cd_<%=jj%>" value='<%=cons.getRent_l_cd()%>'>
        			  <input type='hidden' name='client_id' value='<%=cons.getClient_id()%>'>
        			  <%if(white.equals("")){%>
        			  <span class="b"><a href="javascript:search_car(<%=jj%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span>
        			  <%}%>
        			</td>
        			<td width='13%' class='title'>차명</td>
        			<td width='37%'>&nbsp;
    			    <input type='text' name="car_nm" value='<%=cons.getCar_nm()%>' size='40' class='whitetext' readonly></td>
                </tr>
    		    <tr>
        		    <td class='title'>연식</td>
        			<td>&nbsp;
        			  <input type='text' name="car_y_form" value='<%=car_2.getCar_y_form()%>' size='40' class='whitetext' readonly>
        			</td>
        		    <td class='title'>색상</td>
        			<td>&nbsp;
    			    <input type='text' name="color" value='<%=car_etc.getColo()%>' size='40' class='whitetext' readonly></td>			
    		    </tr>
    		    <tr>
        		    <td class='title'>기본사양</td>
        			<td colspan="3" >&nbsp;
        			  <textarea rows='5' cols='100' name='car_b' readonly><%=cm_bean.getCar_b()%></textarea>        			  
        			</td>
    		    </tr>    	
    		    <tr>
        		    <td class='title'>선택사양</td>
        			<td colspan="3" >&nbsp;
        			  <input type='text' name="opt" value='<%=car_etc.getOpt()%>' size='100' class='whitetext' readonly>
        			</td>
    		    </tr>    	     		    
    		    <tr>
        		    <td class='title'>고객명</td>
        			<td>&nbsp;
        			  <input type='text' name="firm_nm" value='<%=client.getFirm_nm()%>' size='70' class='whitetext' readonly>
        			</td>
        		<td class='title'>하이패스여부</td>
        			<td>&nbsp;
        				<select name="r_hipass_yn" disabled >
                        <option value=''>선택</option>
                        <option value='Y' <%if(car_etc.getHipass_yn().equals("Y"))%>selected<%%>>있음</option>
                        <option value='N' <%if(car_etc.getHipass_yn().equals("N"))%>selected<%%>>없음</option>
                      </select>
          			</td>	
    		    </tr>
		    </table>
	    </td>
    </tr>
    
    <%if(jj==0){%>
	<tr id=tr_cons<%=jj%>_3 style="display:''">
	    <td align="right">&nbsp;
			   <input type='hidden' name='cons_copy' value=''>	  
	    </td>
	</tr>	
	<%}else{%>
	<tr id=tr_cons<%=j%>_3 style="display:''">
	 <td align="right">&nbsp;<input type='hidden' name="cons_copy" value='1' size='2' class='text'>  <a href="javascript:value_copy3(<%=jj%>)">내용복사</a>    	
	    </td>
	</tr>	
    <%}%>
 	
    <tr id=tr_cons<%=jj%>_4 style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr><td class=line2 style='height:1'></td></tr>		  
    		    <tr>
        		    <td colspan="2" class='title'>의뢰자</td>
        		    <td >&nbsp;
        			  <select name='req_id' <%=disabled%>>
                        <option value="">선택</option>
                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(cons.getReq_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%><%if(user.get("DEPT_ID").equals("1000")){%>[에이전트]<%}%></option>
                        <%		}
        					}%>
                      </select>
        			</td>
        		    <td colspan="2" class='title'>탁송구간</td>
        		    <td >&nbsp;
        			  <select name="cmp_app" <%=disabled%>>
        			    <option value="">선택</option>
        				<%for(int i = 0 ; i < c_size2 ; i++){
        					Hashtable code2 = (Hashtable)codes2.elementAt(i);%>
        					<option value='<%=code2.get("NM_CD")%>' <%if(cons.getCmp_app().equals(String.valueOf(code2.get("NM_CD") ))){%>selected<%}%>><%=code2.get("NM")%></option>
        				<%}%>
          			  </select>
        			  <!--(자체탁송일때)-->
        			</td>					
    	        </tr>
				<tr>
					<td colspan="2" class='title'>관리담당자</td>
					<td colspan="4">&nbsp;
						<select name='mng_id' <%=disabled%>>
							<option value="">선택</option>
							<%	if(user_size > 0){
									for(int i = 0 ; i < user_size ; i++){
										Hashtable user = (Hashtable)users.elementAt(i); %>
							<option value='<%=user.get("USER_ID")%>' <%if(base.getMng_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
							<%		}
								}%>
						  </select>
					</td>
				</tr>				
    		    <tr>
    		    <td colspan="2" class='title'>탁송사유</td>
        		    <td colspan="4">&nbsp;
        			  <select name="cons_cau" id="cons_cau<%=jj%>" onChange="javascript:cng_input4(this.value, <%=jj%>)" <%=disabled%>>
        			    <option value="">선택</option>
        				<%for(int i = 0 ; i < c_size ; i++){
        					CodeBean code = codes[i];	%>
        				<option value='<%=code.getNm_cd()%>' ><%= code.getNm()%></option>  	
        			
        				<%}%>
          			  </select>
        			  &nbsp;기타사유 : <input type='text' name="cons_cau_etc" value='<%=cons.getCons_cau_etc()%>' size='40' class='<%=white%>text'>
        			  <input type="button" onclick="cont_search(this.value, <%=j%>)" value="원계약 조회">
        			  <span>원계약 차량 번호</span>
        			  <input type="text" id="sub_car_no" name="sub_car_no" class="text" value="" style="display:none" onclick="test()" readonly>
        			  <input type="text" id="sub_rent_l_cd" name="sub_rent_l_cd" class="sub_rent_l_cd" style="display:none">
        			  <input type="text" id="age_scp" name="age_scp" class="age_scp" style="display:none">
        			</td>        			
        		 	
    	        </tr>
    		    <tr>
        		    <td colspan="2" class='title'>비용구분</td>
        			<td>&nbsp;
        			  <select name="cost_st" <%=disabled%>>
        			    <option value="">선택</option>
        			    <option value="1" <%if(cons.getCost_st().equals("1")){%>selected<%}%>>아마존카</option>
        			    <option value="2" <%if(cons.getCost_st().equals("2")){%>selected<%}%>>고객</option>								
          			  </select>
        			  <%if(white.equals("")){%>
        			  &nbsp;<font color=red>[고객부담]탁송료 : <input type='text' name="cust_amt" value='0' size='7' class='rednum' onBlur='javascript:this.value=parseDecimal(this.value);'>원</font>
        			  <%}else{%>
        			  <%	if(cons.getCost_st().equals("2") && cons.getPay_st().equals("1")){%>
        			  &nbsp;<font color=red>[고객부담]탁송료 : <input type='text' name="cust_amt" value='0' size='7' class='rednum' onBlur='javascript:this.value=parseDecimal(this.value);'>원</font>
        			  <%	}%>
        			  <%}%>
        			</td>						
        		    <td colspan="2" class='title'>지급구분</td>
        			<td>&nbsp;
        			  <select name="pay_st" <%=disabled%>>
        			    <option value="">선택</option>
        			    <option value="1" <%if(cons.getPay_st().equals("1")){%>selected<%}%>>선불</option>
        			    <option value="2" <%if(cons.getPay_st().equals("2")){%>selected<%}%>>후불</option>								
          			  </select>
        			</td>						
    	        </tr>
    		    <tr>
        		    <td rowspan="4" class='title'>요<br>
        	        청</td>
        		    <td class='title'>세차</td>
        		    <td colspan="4">&nbsp;
        			  <select name="wash_yn" <%=disabled%>>
        			    <option value="">선택</option>
        			    <%-- <option value="Y" <%if(cons.getWash_yn().equals("Y")){%>selected<%}%>>요청</option> --%>
        			    <option value="M" <%if(cons.getWash_yn().equals("M")||cons.getWash_yn().equals("Y")){%>selected<%}%>>기계세차</option>
        			    <option value="H" <%if(cons.getWash_yn().equals("H")){%>selected<%}%>>손세차</option>
        			    <option value="N" <%if(cons.getWash_yn().equals("N")){%>selected<%}%>>없음</option>								
          			  </select>
        			</td>
    	        </tr>
    		    <tr>
        		    <td class='title'>주유</td>
        		    <td colspan="4">&nbsp;
        			  <select name="oil_yn" <%=disabled%>>
        			    <option value="">선택</option>
        			    <option value="Y" <%if(cons.getOil_yn().equals("Y")){%>selected<%}%>>요청</option>
        			    <option value="N" <%if(cons.getOil_yn().equals("N")){%>selected<%}%>>없음</option>								
          			  </select>
        				주유요청시 -&gt; 
        			  <input type='text' name="oil_liter" value='<%=Util.parseDecimal(cons.getOil_liter())%>' size='11' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
        				리터<!--ℓ--> 
        				혹은
        			  <input type='text' name="oil_est_amt" value='<%=Util.parseDecimal(cons.getOil_est_amt())%>' size='11' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
        				원어치 주유 해주세요.</td>
    	        </tr>
    		    <tr>
        		    <td class='title'>하이패스등록</td>
        		    <td colspan="4">&nbsp;
        			  <select name="hipass_yn">
        			    <option value="Y" <%if(cons.getHipass_yn().equals("Y")){%>selected<%}%>>요청</option>
        			    <option value="N" <%if(cons.getHipass_yn().equals("N")||cons.getHipass_yn().equals("")){%>selected<%}%>>없음</option>								
          			  </select>
					  (등록대행 의뢰시 선택하십시오.)
        			</td>
    	        </tr>								
    		    <tr>
    		     <input type='hidden' name="other" value='R' > 
    		        <td class='title'>기타</td>
    		        <td colspan="4">&nbsp;
                    <textarea rows='5' cols='90' name='etc' class='<%=white%>'><%=cons.getEtc()%></textarea></td>
    	        </tr>		  
    	    	
    	      <tr>
        		    <td width="3%" rowspan="6" class='title'>출<br>발</td>
        		    <td width="10%" class='title'>구분</td>
        		    <td width="37%">&nbsp;
        			  <select name="from_st" id="from_st" onChange="javascript:cng_input3('from', this.value, <%=jj%>)" <%=disabled%>>
        			    <option value="">선택</option>
        			    <option value="1" <%if(cons.getTo_st().equals("1")){%>selected<%}%>>아마존카</option>
        			    <option value="2" <%if(cons.getTo_st().equals("2")){%>selected<%}%>>고객</option>
        			    <option value="3" <%if(cons.getTo_st().equals("3")){%>selected<%}%>>협력업체</option>				
          			  </select>
        			  <%if(white.equals("")){%>		
        			  <span class="b"><a href="javascript:cng_input3('from', document.form1.from_st[<%=jj%>].options[document.form1.from_st[<%=jj%>].selectedIndex].value, <%=jj%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span>
        			  <%}%>
        			</td>
        		    <td width="3%" rowspan="6" class='title'>도<br>착</td>
        		    <td width="10%" class='title'>구분</td>
        		    <td width="37%">&nbsp;
        			  <select name="to_st" onChange="javascript:cng_input3('to', this.value, <%=jj%>)" <%=disabled%>>
        			    <option value="">선택</option>
        			    <option value="1" <%if(cons.getFrom_st().equals("1")){%>selected<%}%>>아마존카</option>
        			    <option value="2" <%if(cons.getFrom_st().equals("2")){%>selected<%}%>>고객</option>
        			    <option value="3" <%if(cons.getFrom_st().equals("3")){%>selected<%}%>>협력업체</option>
        			    <option value="4" <%if(cons.getFrom_st().equals("4")){%>selected<%}%>>신차출발</option>				
          			  </select>
        			  <%if(white.equals("")){%>			
        			  <span class="b"><a href="javascript:cng_input3('to', document.form1.to_st[<%=jj%>].options[document.form1.to_st[<%=jj%>].selectedIndex].value, <%=jj%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span>
        			  <%}%>
        			</td>			
    		    </tr>
    		    <tr>
        		    <td width="10%" class='title'>장소</td>
        		    <td>&nbsp;
                        <input type='text' name="from_place" value='<%=cons.getTo_place()%>' size='40' class='<%=white%>text' ></td>
        		    <td width="10%" class='title'>장소</td>
        		    <td>&nbsp;
                    <input type='text' name="to_place" id="from_place" value='<%=cons.getFrom_place()%>' size='40' class='<%=white%>text' ></td>
    		    </tr>
    		    <tr>
        		    <td class='title'>상호/성명</td>
        		    <td>&nbsp;
                        <input type='text' name="from_comp" value='<%=cons.getTo_comp()%>' size='40' class='<%=white%>text' >
        				</td>
        		    <td class='title'>상호/성명</td>
        		    <td>&nbsp;
                        <input type='text' name="to_comp" id="from_comp" value='<%=cons.getFrom_comp()%>' size='40' class='<%=white%>text' ></td>
    		    </tr>
    		    <tr>
        		    <td class='title'>담당자</td>
        	        <td>&nbsp;부서/직위
        	          <input type='text' name="from_title" value='<%=cons.getTo_title()%>' size='13' class='<%=white%>text' ><br>
                      &nbsp;성명&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <input type='text' name="from_man" value='<%=cons.getTo_man()%>' size='13' class='<%=white%>text' >
        			  <%if(white.equals("")){%>
        			  <span class="b"><a href="javascript:cng_input5('from', document.form1.from_st[<%=jj%>].options[document.form1.from_st[<%=jj%>].selectedIndex].value, <%=jj%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span>
        			  <%}%>
        			</td>
        		    <td class='title'>담당자</td>
        		    <td>&nbsp;부서/직위
        		      <input type='text' name="to_title" id="from_title" value='<%=cons.getFrom_title()%>' size='13' class='<%=white%>text' ><br>
        			  &nbsp;성명&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        			  <input type='text' name="to_man" id="from_man" value='<%=cons.getFrom_man()%>' size='13' class='<%=white%>text' >
        			  <%if(white.equals("")){%>
        			  <span class="b"><a href="javascript:cng_input5('to', document.form1.to_st[<%=jj%>].options[document.form1.to_st[<%=jj%>].selectedIndex].value, <%=jj%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span>
        			  <%}%>
        			</td>
    		    </tr>
    		    <tr>
        		    <td class='title'>연락처</td>
        		    <td>&nbsp;사무실
                        <input type='text' name="from_tel" value='<%=cons.getTo_tel()%>' size='15' class='<%=white%>text' ><br>
        				&nbsp;핸드폰
                        <input type='text' name="from_m_tel" value='<%=cons.getTo_m_tel()%>' size='15' class='<%=white%>text' >
        			</td>
        		    <td class='title'>연락처</td>
        		    <td>&nbsp;사무실
                        <input type='text' name="to_tel" id="from_tel" value='<%=cons.getFrom_tel()%>' size='15' class='<%=white%>text' ><br>
        				&nbsp;핸드폰
                        <input type='text' name="to_m_tel" id="from_m_tel" value='<%=cons.getFrom_m_tel()%>' size='15' class='<%=white%>text' >
        			</td>
    		    </tr>
    		 
    		    <tr>
        		    <td class='title'>요청일시</td>
        		    <td>&nbsp;
        			  <%	String from_req_dt = "";
        			  		String from_req_h = "";
        					String from_req_s = "";
        			  		if(cons.getFrom_req_dt().length() == 12){
        						from_req_dt = cons.getFrom_req_dt().substring(0,8);
        						from_req_h 	= cons.getFrom_req_dt().substring(8,10);
        						from_req_s	= cons.getFrom_req_dt().substring(10,12);
        					}%>
                      <input type='text' name="from_req_dt" value='<%=AddUtil.getDate()%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value);'>
                      &nbsp;
        			  <select name="from_req_h" onchange="javascript:document.form1.to_req_h[<%=jj%>].value=this.value;" <%=disabled%>>
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" ><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="from_req_s" onchange="javascript:document.form1.to_req_s[<%=j%>].value=this.value;" <%=disabled%>>
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" ><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                    </td>
        		    <td class='title'>요청일시</td>
        		    <td>&nbsp;
        			  <%	String to_req_dt = "";
        			  		String to_req_h = "";
        					String to_req_s = "";
        			  		if(cons.getTo_req_dt().length() == 12){
        						to_req_dt 	= cons.getTo_req_dt().substring(0,8);
        						to_req_h 	= cons.getTo_req_dt().substring(8,10);
        						to_req_s 	= cons.getTo_req_dt().substring(10,12);
        					}%>			
                      <input type='text' name="to_req_dt" value='<%=AddUtil.getDate()%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                      &nbsp;
        			  <select name="to_req_h" <%=disabled%>>
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" ><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="to_req_s" <%=disabled%>>
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" ><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                    </td>
    	        </tr>
    	        <tr>
        		    <td colspan="2" class='title'>운전자명</td>
                    <td>&nbsp;
                        <input type='text' name="driver_nm" value='' size='15' class='text' >
        				<input type='hidden' name="driver_id" value=''>
        				<span class="b"><a href="javascript:cng_input6('driver','3',<%=jj%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif" align="absbottom" border="0"></a></span>
        			</td>
                    <td colspan="2" class='title'>운전자핸드폰</td>
                    <td>&nbsp;
                        <input type='text' name="driver_m_tel" value='' size='15' class='text' ></td>
    	        </tr>  
            </table>
        </td>
    </tr>
	<tr id=tr_cons<%=jj%>_5 style="display:''">
	    <td align="right">&nbsp;<a href="javascript:ConsPrint(<%=cons.getSeq()%>)"><img src="../../images/printer.gif" border="0"></a>
	  <%Vector vt = cs_db.getConsignmentCarList(cons.getCar_no(), from_req_dt);
		int vt_size = vt.size();
		if(vt_size>1){%>
		<a href="javascript:ConsCarList('<%=cons.getCar_no()%>','<%=from_req_dt%>')"><font color=red>동일차량/동일요청일로 등록된 탁송의뢰가 있습니다.</font></a>&nbsp;
	  <%}%>
	    </td>
	</tr>		
	<%
	   jj = jj + 1;
	}%>	
	
	<!-- 편도 선택시 껍데기 -->
	<% if (	b_cons.getCons_su() < 2 ) { %>
	
		  <input type='hidden' name="car_no" >
          <input type='hidden' name='seq' >
          <input type='hidden' name='car_mng_id' id="car_mng_id_1" >
          <input type='hidden' name='rent_mng_id' >
          <input type='hidden' name='rent_l_cd' id="rent_l_cd_1">
          <input type='hidden' name='client_id' >
          <input type='hidden' name="car_nm" >   
          <input type='hidden' name="r_hipass_yn" >
          <input type='hidden' name='cons_copy' >
          <input type='hidden' name='req_id'  >
          <input type='hidden' name='cmp_app' >
          <input type='hidden' name='cons_cau' id="cons_cau1">
          <input type='hidden' name='cons_cau_etc' >
          
          <input type='hidden' name="cost_st" >
          <input type='hidden' name='cust_amt' >
          <input type='hidden' name='pay_st'  >
          <input type='hidden' name='wash_yn' >
          <input type='hidden' name='oil_yn'>
          <input type='hidden' name='oil_liter' >
          <input type='hidden' name="oil_est_amt" >   
          <input type='hidden' name="hipass_yn" >
          <input type='hidden' name='other' >
          <input type='hidden' name='etc'  >
          <input type='hidden' name='from_st' >
          <input type='hidden' name='to_st' >
          
          <input type='hidden' name='from_place' >   
          <input type='hidden' name='to_place' >   
          <input type='hidden' name='from_comp' >   
          <input type='hidden' name='to_comp' >   
          <input type='hidden' name='from_title' >   
          <input type='hidden' name='from_man' >   
          <input type='hidden' name='to_title' >   
          <input type='hidden' name='to_man' >   
          
          <input type='hidden' name='from_tel' >   
          <input type='hidden' name='from_m_tel' >   
          <input type='hidden' name='to_tel' >   
          <input type='hidden' name='to_m_tel' >   
          <input type='hidden' name='from_req_dt' >   
          <input type='hidden' name='from_req_h' >   
          <input type='hidden' name='from_req_s' >  
          <input type='hidden' name='to_req_dt' >   
          <input type='hidden' name='to_req_h' >   
          <input type='hidden' name='to_req_s' >   
           
          <input type='hidden' name='driver_nm' >   
          <input type='hidden' name='driver_id' >   
          <input type='hidden' name='driver_m_tel' >  
                      			  	
	<% } %>
	
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
	<input type="hidden" name='ac_ot_fault_per' value='100'>
	<input type="hidden" name="bond_trf_yn" id="bond_trf_yn" value="N" />
	
    <tr class='bondForm' style="display:none;">
	    <td class=h></td>
	</tr>
    <tr class='bondForm' style="display:none;">
		<td>
			<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>채권양도 통지서 및 위임장</span>
			<!-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="checkbox" name="bond_trf_chk" checked> 채권양도 통지서 및 위임장을 생성합니다. -->
			<div style="padding-top:5px; padding-bottom:5px;">※ 사고대차회수 탁송은 채권양도통지서 및 위임장도 함께 생성합니다(사고등록필수). 사고등록여부 확인 후 탁송의뢰해주세요.</div>
			<div style="padding-top:5px; padding-bottom:5px;">※ 하단에 입력한 정보는 오직 채권양도 통지서 문서 생성을 위해서만 사용될뿐 사고등록에 연동되지않습니다. 정확한 정보는 사고조회에서 추가입력해주세요.</div>
		</td>
    </tr>
    <tr class='bondForm' style="display:none;">
        <td class='line' width="898"> 
            <table border="0" cellspacing="1" cellpadding="0" width=897>
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