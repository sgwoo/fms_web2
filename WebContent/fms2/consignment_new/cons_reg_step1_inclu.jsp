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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>Ź��<%=j+1%></span>
		
		</td>
	</tr>
    <tr id=tr_cons<%=j%>_2 style="display:<%=display%>"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr><td class=line2 style='height:1'></td></tr>
				<%	
					
				%>
                <tr> 
                    <td width='13%' class='title'>������ȣ/�����ȣ</td>
                    <td width='37%'>&nbsp;
        			  <input type='text' name="car_no" value='<%=car.get("CAR_NO")==null?"":car.get("CAR_NO")%>' size='25' class='text' onKeyDown="javasript:enter('car_no', <%=j%>)" style="IME-MODE:active;">
        			  <input type='hidden' name='car_mng_id' id="car_mng_id_<%=j%>" value='<%=car.get("CAR_MNG_ID")==null?"":car.get("CAR_MNG_ID")%>'>
        			  <input type='hidden' name='rent_mng_id' value='<%=car.get("RENT_MNG_ID")==null?"":car.get("RENT_MNG_ID")%>'>
        			  <input type='hidden' name='rent_l_cd' id="rent_l_cd_<%=j%>" value='<%=car.get("RENT_L_CD")==null?"":car.get("RENT_L_CD")%>'>
        			  <input type='hidden' name='client_id' value='<%=car.get("CLIENT_ID")==null?"":car.get("CLIENT_ID")%>'>
        			    <span class="b"><a href="javascript:search_car(<%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
						&nbsp;&nbsp;&nbsp;		
						<span class="b"><a href="javascript:search_car_res(<%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">[��/���� ���� ��ȸ]</a></span>
        			</td>
        			<td width='13%' class='title'>����</td>
        			<td width='37%'>&nbsp;
        			  <input type='text' name="car_nm" value='<%=car.get("CAR_NM")==null?"":car.get("CAR_NM")%> <%=car.get("CAR_NAME")==null?"":car.get("CAR_NAME")%>' size='40' class='whitetext' readonly>
        			  <span class="b"><a href="javascript:view_car(<%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_see.gif"  border="0" align=absmiddle></a></span>
        			  </td>
                </tr>
    		    <tr>
        		    <td class='title'>����</td>
        			<td>&nbsp;
        			  <input type='text' name="car_y_form" value='<%=car.get("CAR_Y_FORM")==null?"":car.get("CAR_Y_FORM")%>' size='40' class='whitetext' readonly>
        			</td>
        		    <td class='title'>����</td>
        			<td>&nbsp;
        			  <input type='text' name="color" value='<%=car.get("COLO")==null?"":car.get("COLO")%>' size='40' class='whitetext' readonly></td>			
    		    </tr>
    		    
    		    <tr>
        		    <td class='title'>�⺻���</td>
        			<td colspan="3" >&nbsp;
        			  <textarea rows='5' cols='100' name='car_b' readonly><%=car.get("CAR_B")==null?"":car.get("CAR_B")%></textarea>        			  
        			</td>
    		    </tr>    	
    		    <tr>
        		    <td class='title'>���û��</td>
        			<td colspan="3" >&nbsp;
        			  <input type='text' name="opt" value='<%=car.get("OPT")==null?"":car.get("OPT")%>' size='100' class='whitetext' readonly>
        			</td>
    		    </tr>    	    		   
    		    
    		    <tr>
        		    <td class='title'>����</td>
        			<td>&nbsp;
        			  <input type='text' name="firm_nm" value='<%=car.get("FIRM_NM")==null?"":car.get("FIRM_NM")%>' size='60' class='whitetext' readonly>
        			</td>
        		    <td class='title'>�����н�����</td>
        			<td>&nbsp;
        				<input type='text' name="r_hipass_yn" value='<%=car.get("HIPASS_YN")==null?"":car.get("HIPASS_YN")%>' size='10' class='whitetext' readonly>
          			</td>	
        				  <!--
        		    <td class='title'>��������</td>
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
			  <span class="b"><a href="javascript:view_car_sh(<%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_dgir.gif"  border="0" align=absmiddle></a></span>&nbsp;
			  <span class="b"><a href="javascript:view_car_lh(<%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_jgir.gif"  border="0" align=absmiddle></a></span>
			  <input type='hidden' name='cons_copy' value=''>	  
	    </td>
	</tr>	
	<%}else{%>
	<tr id=tr_cons<%=j%>_3 style="display:<%=display%>">
	    <td align="right">
	    &nbsp;<input type='text' name="cons_copy" value='' size='2' class='text'>�� Ź�� <a href="javascript:value_copy(<%=j%>)">���뺹��</a>
		&nbsp;/<a href="javascript:value_copy2(<%=j%>)">�պ�</a>
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
        		    <td colspan="2" class='title'>�Ƿ���</td>
        		    <td >&nbsp;
        			  <select name='req_id'>
                        <option value="">����</option>
                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}%>
                      </select>
        			</td>
        		    <td colspan="2" class='title'>Ź�۱���</td>
        		    <td>&nbsp;        		    
        		    <!-- ������ ��� �ʼ����� : ��� setting -->
        			  <select name="cmp_app">
        			        <option value=''>Ź�۱����� �����ϼ���</option>
        			     </td>
        		
    	        </tr>				
    		    <tr>
        		    <td colspan="2" class='title'>Ź�ۻ���</td>
        		    <td colspan="4">&nbsp;
        			  <select name="cons_cau" id="cons_cau<%=j%>" onChange="javascript:cng_input4(this.value, <%=j%>)">
        			    <option value="">����</option>
        				<%for(int i = 0 ; i < c_size ; i++){
        					CodeBean code = codes[i];	%>
        				<option value='<%=code.getNm_cd()%>' <%if(cons_cau.equals(code.getNm_cd()))%>selected<%%>><%= code.getNm()%></option>
        				<%}%>
          			  </select>
        			  &nbsp;��Ÿ���� : <input type='text' name="cons_cau_etc" value='' size='40' class='text'>
        			  &nbsp;<font color="#666666">(�ѱ� 25�� �̳�)</font>
        			  <input type="button" id="search" name="search" onclick="" value="����� ��ȸ" style="display:none">
        			  <span id="car_no_text" name="car_no_text" style="display:none">����� ���� ��ȣ</span> 
        			  <input type="text" id="sub_car_no" name="sub_car_no" class="text" value="" style="display:none" onclick="test()" readonly>
        			  <input type="text" id="sub_rent_l_cd" name="sub_rent_l_cd" class="sub_rent_l_cd" style="display:none">
        			  <input type="text" id="age_scp" name="age_scp" class="age_scp" style="display:none">
        			</td>
    	        </tr>
    		    <tr>
        		    <td colspan="2" class='title'>��뱸��</td>
        			<td>&nbsp;
        			  <select name="cost_st">
        			    <option value="">����</option>
        			    <option value="1" <%if(cost_st.equals("1"))%>selected<%%>>�Ƹ���ī</option>
        			    <option value="2" <%if(cost_st.equals("2"))%>selected<%%>>��</option>								
          			  </select>
        			  &nbsp;<font color=red>[���δ�]Ź�۷� : <input type='text' name="cust_amt" value='0' size='7' class='rednum' onBlur='javascript:this.value=parseDecimal(this.value);'>��</font>
        			</td>						
        		    <td colspan="2" class='title'>���ޱ���</td>
        			<td>&nbsp;
        			  <select name="pay_st">
        			    <option value="">����</option>
        			    <option value="1" <%if(pay_st.equals("1"))%>selected<%%>>����</option>
        			    <option value="2" <%if(pay_st.equals("2"))%>selected<%%>>�ĺ�</option>								
          			  </select>
        			</td>						
    	        </tr>
    		    <tr>
        		    <td rowspan="4" class='title'>��<br>
        	        û</td>
        		    <td class='title'>����</td>
        		    <td colspan="4">&nbsp;
        			  <select name="wash_yn">
        			    <!-- <option value="Y">��û</option> -->
        			    <option value="M">��輼��</option>
        			    <option value="H">�ռ���</option>
        			    <option value="N" selected>����</option>								
          			  </select>
        			</td>
    	        </tr>
    		    <tr>
        		    <td class='title'>����</td>
        		    <td colspan="4">&nbsp;
        			  <select name="oil_yn">
        			    <option value="Y">��û</option>
        			    <option value="N" selected>����</option>								
          			  </select>
        				������û�� -&gt; 
        			  <input type='text' name="oil_liter" value='' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
        				����<!--��--> 
        				Ȥ��
        			  <input type='text' name="oil_est_amt" value='' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
        				����ġ ���� ���ּ���.</td>
    	        </tr>
    		    <tr>
        		    <td class='title'>�����н����</td>
        		    <td colspan="4">&nbsp;
        			  <select name="hipass_yn">
        			    <option value="Y">��û</option>
        			    <option value="N" selected>����</option>								
          			  </select>
					  (��ϴ��� �Ƿڽ� �����Ͻʽÿ�.)
        			</td>
    	        </tr>				
    		    <tr>
    		      <input type='hidden' name="other"  > 
        		    <td class='title'>��Ÿ</td>
        		    <td colspan="4">&nbsp;
                      <textarea rows='5' cols='90' name='etc' style="color:red"></textarea></td>
    	        </tr>		  
    		    <tr>
        		    <td width="3%" rowspan="6" class='title'>��<br>��</td>
        		    <td width="10%" class='title'>����</td>
        		    <td width="37%">&nbsp;
        			  <select name="from_st" id="from_st" style="width:150px;" onChange="javascript:cng_input3('from', this.value, <%=j%>)">
        			    <option value="">����</option>
        			    <option value="1">�Ƹ���ī</option>
        			    <option value="2">��</option>
        			    <option value="3">���¾�ü</option>
        			    <option value="4">�������</option>				
          			  </select>		
        			  <span class="b"><a href="javascript:cng_input3('from', document.form1.from_st[<%=j%>].options[document.form1.from_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			</td>
        		    <td width="3%" rowspan="6" class='title'>��<br>��</td>
        		    <td width="10%" class='title'>����</td>
        		    <td width="37%">&nbsp;
        			  <select name="to_st" style="width:150px;" onChange="javascript:cng_input3('to', this.value, <%=j%>)">
        			    <option value="">����</option>
        			    <option value="1">�Ƹ���ī</option>
        			    <option value="2">��</option>
        			    <option value="3">���¾�ü</option>				
          			  </select>			
        			  <span class="b"><a href="javascript:cng_input3('to', document.form1.to_st[<%=j%>].options[document.form1.to_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			</td>			
    		    </tr>
    		    <tr>
        		    <td width="10%" class='title'>���</td>
        		    <td>&nbsp;
                        <input type='text' name="from_place" id="from_place" value='' size='40' class='text' ></td>
        		    <td width="10%" class='title'>���</td>
        		    <td>&nbsp;
                        <input type='text' name="to_place" value='' size='40' class='text' ></td>
    		    </tr>
    		    <tr>
        		    <td class='title'>��ȣ/����</td>
        		    <td>&nbsp;
                        <input type='text' name="from_comp" id="from_comp" value='' size='40' class='text' >
        				</td>
        		    <td class='title'>��ȣ/����</td>
        		    <td>&nbsp;
                        <input type='text' name="to_comp" value='' size='40' class='text' ></td>
    		    </tr>
    		    <tr>
        		    <td class='title'>�����</td>
        	        <td>&nbsp;�μ�/����
        	          <input type='text' name="from_title" id="from_title" value='' size='20' class='text' ><br>
                      &nbsp;����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <input type='text' name="from_man" id="from_man" value='' size='20' class='text' >
        			  <span class="b"><a href="javascript:cng_input5('from', document.form1.from_st[<%=j%>].options[document.form1.from_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			</td>
        		    <td class='title'>�����</td>
        		    <td>&nbsp;�μ�/����
        		      <input type='text' name="to_title" value='' size='20' class='text' ><br>
        			  &nbsp;����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        			  <input type='text' name="to_man" value='' size='20' class='text' >
        			  <span class="b"><a href="javascript:cng_input5('to', document.form1.to_st[<%=j%>].options[document.form1.to_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			</td>
    		    </tr>
    		    <tr>
        		    <td class='title'>����ó</td>
        		    <td>&nbsp;�繫��
                        <input type='text' name="from_tel" id="from_tel" value='' size='15' class='text' ><br>
        				&nbsp;�ڵ���
                        <input type='text' name="from_m_tel" id="from_m_tel" value='' size='15' class='text' >
        			</td>
        		    <td class='title'>����ó</td>
        		    <td>&nbsp;�繫��
                        <input type='text' name="to_tel" value='' size='15' class='text' ><br>
        				&nbsp;�ڵ���
                        <input type='text' name="to_m_tel" value='' size='15' class='text' >
        			</td>
    		    </tr>
    		    <tr>
        		    <td class='title'>��û�Ͻ�</td>
        		    <td>&nbsp;
                      <input type='text' name="from_req_dt" value='<%=AddUtil.getDate()%>' size='11' class='text' onBlur='javascript:this.value=ChangeDate(this.value); document.form1.to_req_dt[<%=j%>].value=this.value;'>
                      &nbsp;
        			  <select name="from_req_h" onchange="javascript:document.form1.to_req_h[<%=j%>].value=this.value;">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="from_req_s" onchange="javascript:document.form1.to_req_s[<%=j%>].value=this.value;">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                    </td>
        		    <td class='title'>��û�Ͻ�</td>
        		    <td>&nbsp;
                      <input type='text' name="to_req_dt" value='<%=AddUtil.getDate()%>' size='11' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                      &nbsp;
        			  <select name="to_req_h">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="to_req_s">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                    </td>
    	        </tr>
    		    <tr>
        		    <td colspan="2" class='title'>�����ڸ�</td>
                    <td>&nbsp;
                        <input type='text' name="driver_nm" value='' size='15' class='text' >
        				<input type='hidden' name="driver_id" value=''>
        				<span class="b"><a href="javascript:cng_input6('driver','3',<%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif" align="absbottom" border="0"></a></span>
        			</td>
                    <td colspan="2" class='title'>�������ڵ���</td>
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
<!-- Ź�ۻ���:������ȸ�� > ä�Ǿ絵 ������ �� on -->
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
	<input type="hidden" name="ac_ins_req_gu" value="2" /><!-- 2:������ -->
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
			<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ä�Ǿ絵 ������ �� ������</span>
			<!-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="checkbox" name="bond_trf_chk" checked> ä�Ǿ絵 ������ �� �������� �����մϴ�.<br> -->
			<div style="padding-top:5px; padding-bottom:5px;">�� ������ȸ�� Ź���� ä�Ǿ絵������ �� �����嵵 �Բ� �����մϴ�(������ʼ�). ����Ͽ��� Ȯ�� �� Ź���Ƿ����ּ���.</div>
			<div style="padding-top:5px; padding-bottom:5px;">�� �ϴܿ� �Է��� ������ ���� ä�Ǿ絵 ������ ���� ������ ���ؼ��� ���ɻ� ����ϰ� ���������ʽ��ϴ�. ��Ȯ�� ������ �����ȸ���� �߰��Է����ּ���.</div>
		</td>
    </tr>
    <tr class='bondForm' style="display:<%if(cons_cau_10 > 0){ %>''<%}else{%>none<%}%>;"> 
        <td class='line' width="100%"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr><td class=line2 style='height:1'></td></tr>
    			<tr>
    				<td class='title' width="15%">����/���/Ź����ȸ</td>
    				<td  width="85%">&nbsp;
    					<span class="b"><a href="javascript:search_total();" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
    				</td>
    			</tr>
    			<tr>
    				<td class='title'>�������</td>
    				<td>&nbsp;<input type="text" name="accid_dt" class="text" value=""/></td>
    			</tr>
    			<tr>
    				<td class='title'>����ó(�����/��ȣ)</td>
    				<td>&nbsp;<input type="text" name="ins_com_nm" class="text"/>
    					&nbsp;&nbsp;&nbsp;�� �������-�ֹ�/����/���� ���� ��뺸���, �ܵ� ���� ����ȣ�� �Է� </td>
    			</tr>
    			<tr>
    				<td class='title'>�����Ⱓ</td>
    				<td>&nbsp;
    					<input type="text" name="ins_use_st" value="<%-- <%=AddUtil.ChangeDate2(i_start_dt)%> --%>" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);' maxlength="10">

					  <select name="use_st_h">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%-- <%if(i_start_h.equals(AddUtil.addZero2(i))){%>selected<%}%> --%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="use_st_s">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%-- <%if(i_start_s.equals(AddUtil.addZero2(i))){%>selected<%}%> --%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>	

                      ~ 
                      <input type="text" name="ins_use_et" value="<%-- <%=AddUtil.ChangeDate2(i_end_dt)%> --%>" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value); set_ins_use_dt();' maxlength="10">

					  <select name="use_et_h" onChange="javscript:set_ins_use_dt();">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%-- <%if(i_end_h.equals(AddUtil.addZero2(i))){%>selected<%}%> --%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="use_et_s" onChange="javscript:set_ins_use_dt();">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%-- <%if(i_end_s.equals(AddUtil.addZero2(i))){%>selected<%}%> --%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>	

                      ( 
                      <input type="text" name="ins_use_day" value="<%-- <%=ma_bean.getIns_use_day()%> --%>" size="3" class=num onBlur='javscript:set_ins_amt();'>
                      ��					  
					  <input type="text" name="use_hour" value="<%-- <%=ma_bean.getUse_hour()%> --%>" size="2" class=num onBlur='javscript:set_ins_amt();'>
                      �ð� 	
					  )
        			  &nbsp;&nbsp;<span class="b"><a href="javascript:set_reqamt('')" onMouseOver="window.status=''; return true" title="����ϱ�"><img src="/acar/images/center/button_in_cal.gif" align="absmiddle" border="0"></a></span>
        			  <span class="b"><a href="javascript:set_reqamt('view')" onMouseOver="window.status=''; return true" title="���� ����"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a></span>
    				</td>
    			</tr>
    			<tr>
    				<td class='title'>������</td>
    				<td>&nbsp;<input type="text" name="ins_req_amt" class="text"/>�� 
    					<br>&nbsp;(������[û���ݾ�]=((1��û������*�����ϼ�)+(1��û������/24*�����ð�))*��������)
    					
    				</td>
    			</tr>
    		</table>
    	</td>
    </tr>