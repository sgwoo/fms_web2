<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.offls_yb.*, acar.common.*, acar.estimate_mng.*"%>
<jsp:useBean id="olyBean" class="acar.offls_yb.Offls_ybBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="srBn" class="acar.secondhand.ShResBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");		
	
	String gubun 		= request.getParameter("gubun")		==null?"":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")	==null?"":request.getParameter("gubun_nm");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String brch_id 		= request.getParameter("brch_id")	==null?"":request.getParameter("brch_id");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String res_yn 		= request.getParameter("res_yn")	==null?"":request.getParameter("res_yn");
	String res_mon_yn	= request.getParameter("res_mon_yn")	==null?"":request.getParameter("res_mon_yn");
	String all_car_yn	= request.getParameter("all_car_yn")	==null?"":request.getParameter("all_car_yn");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	if(!gubun_nm.equals("")) gubun_nm = AddUtil.replace(gubun_nm,"'","");
		
//	Vector vts = shDb.getSecondhandList_20120821(gubun2, gubun, gubun_nm, brch_id, sort_gubun, res_yn, res_mon_yn, all_car_yn);
	Vector vts = shDb.getSecondhandList_20120821(gubun2, gubun, gubun_nm, brch_id, sort_gubun, res_yn, res_mon_yn, all_car_yn, "");
	int vt_size = vts.size();
	
	
	long total_c_amt = 0;
	long total_f_amt = 0;
	long total_rb_amt = 0;
	long total_lb_amt = 0;
%>

<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript" src="/include/table_fix.js?ver=0.2"></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css?ver=0.2">
<link rel="stylesheet" type="text/css" href="/include/table_fix.css?ver=0.2">

<script language='javascript'>
<!--
	var checkflag = "false";
	function AllSelect(field){
		if(checkflag == "false"){
			for(i=0; i<field.length; i++){
				field[i].checked = true;
			}
			checkflag = "true";
			return;
		}else{
			for(i=0; i<field.length; i++){
				field[i].checked = false;
			}
			checkflag = "false";
			return;
		}
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
	//주차현황
	function parking_car(car_mng_id, io_gubun, park_id)
	
	{
		window.open("/fms2/park_home/parking_check_frame.jsp?car_mng_id="+car_mng_id+"&io_gubun=1&park_id="+park_id+"&st=1", "PARKING_CAR", "left=100, top=20, width=1000, height=900, scrollbars=auto");
	}	

	//사고사진
	function accid_pic(car_mng_id, accid_id)
	
	{
		window.open("/acar/accid_mng/accid_u_in10.jsp?car_mng_id="+car_mng_id+"&accid_id="+accid_id+"&mode=view", "ACCID_PIC", "left=100, top=20, width=1000, height=900, scrollbars=auto");
	}	
	
-->
</script>
</head>

<body>
<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='height' id="height" value='<%=height%>'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="sort_gubun" value="<%=sort_gubun%>">
<input type="hidden" name="brch_id" value="<%=brch_id%>">
<input type="hidden" name="res_yn" value="<%=res_yn%>">
<input type="hidden" name="res_mon_yn" value="<%=res_mon_yn%>">
<input type="hidden" name="all_car_yn" value="<%=all_car_yn%>">

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 565px;">
					<div style="width: 565px;">
						<table class="inner_top_table left_fix" style="height: 60px;">				
							
							<tr> 
                                <td width='30' class='title title_border' rowspan="2"> <input type="checkbox" name="all_pr" value="Y" onclick='javascript:AllSelect(this.form.pr)'></td>
                                <td width='40' class='title title_border' rowspan="2">연번</td>
                                <td width='125' class='title title_border' rowspan="2">내용</td>
                                <td class='title title_border' colspan="4">예약</td>		
								<td class='title title_border' width="50" rowspan="2">상태</td>
                                <td width='80' class='title title_border' rowspan="2">차량번호</td>                             
                            </tr>
                            <tr> 
                                <td class='title title_border' width="60">상태</td>
                                <td class='title title_border' width="90">1순위</td>
                                <td class='title title_border' width="45">2순위</td>
                                <td class='title title_border' width='45'>3순위</td>
                            </tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">	
						
							 <colgroup>
							 	<col width="170">
				       			<col width="50">
				       			<col width="60">
				       			<col width="80">
				       			<col width="85"><!-- 최초등록일 -->				       			       				       					       			
				       			<col width="45">
				       			<col width="40">
				       			<col width="30">
				       			<col width="60">     
				       			<col width="70">
				       			
				       			<col width="60">			       			
				       			<col width="60">		       			
				       			<col width="60">		
				       			<col width="60"> <!-- 재리스 -->
				       			
				       			<col width="70">  			
				       			<col width="30">
				       					       			
				       			<col width="80">
				       			<col width="75"> <!-- 2위 -->
				       			
				       			<col width="60">			       			
				       			<col width="150">		       			
				       			<col width="85">		
				       			<col width="85">			
				       			<col width="85">	
				       			<col width="80">	
				       		</colgroup>
												
							<tr> 
							    <td width='170' class='title title_border' rowspan="2">차명</td>
            			        <td width='50' class='title title_border' rowspan="2">재리스<br>사진</td>
                                <td width='60' class='title title_border' rowspan="2">연료</td>
                                <td width='80' class='title title_border' rowspan="2">색상</td>
            			        <td width='85' class='title title_border' rowspan="2">최초<br>등록일</td>
						        <td width='45' class='title title_border' rowspan="2">모델<br>연도</td>
						        <td width='40' class='title title_border' rowspan="2">자산<br>양수</td>
            			        <td width='30' class='title title_border' rowspan="2">차령</td>		
                                <td width='60' class='title title_border' rowspan="2">주행<br>거리</td>
                                <td width='70' class='title title_border' rowspan="2">최대계약<br>개월수</td>
                                <td class='title title_border' colspan="3">재렌트</td>
                                <td class='title title_border'>재리스</td>
                                <td width='70' class='title title_border' rowspan="2">주차장</td>
                                <td width='30' class='title title_border' rowspan="2">사고<br>유무</td>
                                <td class='title title_border' colspan="2">사고수리비</td>
                                <td width='60' class='title title_border' rowspan="2">사고사진</td>
                                <td width='150' class='title title_border' rowspan="2">선택사양</td>
                                <td width='85' class='title title_border' rowspan="2">재리스사진<br>등록일자</td>
                                <td width='85' class='title title_border' rowspan="2">재리스<br>등록일자</td>
                                <td width='85' class='title title_border' rowspan="2">대여료<br>수정일</td>
                                <td width='80' class='title title_border' rowspan="2">차종코드</td>
                            </tr>
                            <tr> 
                                <td width='60' class='title title_border'>12개월</td>
				                <td width='60' class='title title_border'>24개월</td>
                            	<td class='title title_border' width="60">36개월</td>
                            	<td class='title title_border' width="60">36개월</td>
                            	<td class='title title_border' width="80">1위</td>
                            	<td class='title title_border' width="75">2위</td>
                            </tr>	        		
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="tb_box">
		<table class="tb">
			<tr>
				<td style="width: 565px;">
					<div style="width: 565px;">
						<table class="inner_top_table left_fix">  
		<%	if(vt_size > 0){%>	        
                <%for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);%>
                            <tr style="height: 25px;"> 
                                <td width='30' class='center content_border'><input type="checkbox" name="pr" value="<%=ht.get("CAR_MNG_ID")%>"></td>
                                <td width='40' class='center content_border'><%=i+1%></td>
                                <td width='125' class='center content_border'>
								<% if(!String.valueOf(ht.get("ACTN_ST")).equals("")){ 
										//경매정보
										Hashtable ht_apprsl 	= shDb.getCarApprsl(String.valueOf(ht.get("CAR_MNG_ID")));%>
									<font color=green>	
									<% if(String.valueOf(ht.get("ACTN_ST")).equals("유찰")){ %>
                                	<span title='[<%=ht.get("ACTN_ST")%>] 경매장:<%=ht_apprsl.get("FIRM_NM")%>, 평가일자:<%=AddUtil.ChangeDate2(String.valueOf(ht_apprsl.get("APPRSL_DT")))%>, 경매일자:<%=ht.get("ACTN_DT")%>, 다음경매예정일:<%=ht.get("ACTN_EST_DT")%>'>경매:<%=ht.get("ACTN_EST_DT")%> </span> 												
									<% }else{%>
                                	<span title='[<%=ht.get("ACTN_ST")%>] 경매장:<%=ht_apprsl.get("FIRM_NM")%>, 평가일자:<%=AddUtil.ChangeDate2(String.valueOf(ht_apprsl.get("APPRSL_DT")))%>, 경매일자:<%=ht.get("ACTN_DT")%> <%if(String.valueOf(ht.get("RENT_ST")).equals("네고중")){ %> ( <%=ht.get("SITU_NM")%>)  <%} %> '><%=ht.get("RENT_ST")%></span> 												
									<% }%>
									</font>		
								<%}else{%>	
									<% 	if(String.valueOf(ht.get("RENT_ST")).equals("대기")){ %>
										<%=ht.get("RENT_ST")%><font color='#999999'><span title='<%=ht.get("PARK")%> <%=ht.get("PARK_CONT")%>'>(<%=AddUtil.subData(String.valueOf(ht.get("PARK")),4)%>)</span></font>
									<% 	}else if(String.valueOf(ht.get("RENT_ST")).equals("매각결정")){ %>
										<font color="red"><%=ht.get("RENT_ST")%></font>
									<% 	}else if(String.valueOf(ht.get("RENT_ST")).equals("차량정비")){ %>
										정비<font color='#999999'><span title='<%=ht.get("PARK")%>'>(<%=AddUtil.subData(String.valueOf(ht.get("PARK")),4)%>)</span></font>
									<%	}else{%>
										<span title='[<%=ht.get("RENT_ST")%>] 반차예정일:<%=ht.get("RET_PLAN_DT")%>'><%if(String.valueOf(ht.get("RENT_ST")).equals("월렌트")){%><font color="red"><%=ht.get("RENT_ST")%></font><%}else{%><%=ht.get("RENT_ST")%><%}%><font color='#999999'><%=AddUtil.ChangeDate(String.valueOf(ht.get("RET_PLAN_DT")),"MM/DD")%></font></span> 
									<%	}%>									
                                <% } %>
                                </td>
                                <td width='60' class='center content_border'><%=ht.get("SITUATION")%></td>				  								
                                <td width='90' class='center content_border'>
	                                   <font color="#FF66FF"><span title='<%=ht.get("MEMO")%> 예약기간:<%=ht.get("RES_ST_DT")%>~<%=ht.get("RES_END_DT")%>'><%=ht.get("SITU_NM")%><%=AddUtil.ChangeDate(String.valueOf(ht.get("RES_END_DT")),"MM/DD")%></span></font> 
                                </td>								
								<%if(String.valueOf(ht.get("RES_CNT")).equals("1")||String.valueOf(ht.get("RES_CNT")).equals("2")){ 
										Vector sr = shDb.getShResList(String.valueOf(ht.get("CAR_MNG_ID")));
										int sr_size = sr.size();
										if(sr_size >3) sr_size=3;
										for(int j = 1 ; j < sr_size ; j++){
											Hashtable sr_ht = (Hashtable)sr.elementAt(j);%>
                                <td width='45' class='center content_border'><%=c_db.getNameById(String.valueOf(sr_ht.get("DAMDANG_ID")),"USER")%></td>
								<%		}%>
								<%		if(sr_size==2){%>
                                <td width='45' class='center content_border'>&nbsp;</td>
								<%		}%>
								<%		if(sr_size==1){%>
                                <td width='45' class='center content_border'>&nbsp;</td>
                                <td width='45' class='center content_border'>&nbsp;</td>
								<%		}%>
								<%}else{%>
                                <td width='45' class='center content_border'>&nbsp;</td>
                                <td width='45' class='center content_border'>&nbsp;</td>
								<%}%>
								<td width='50' class='center content_border'><span title='<%=ht.get("RM_CONT")%>'><%if(String.valueOf(ht.get("RM_ST")).equals("즉시")){%><font color=red><%}%><%=ht.get("RM_ST")%><%if(String.valueOf(ht.get("RM_ST")).equals("즉시")){%></font><%}%></span></td>
                                <td width='80' class='center content_border'><a href="javascript:parent.view_detail('<%=auth_rw%>','<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("JG_CODE")%>')"><%=ht.get("CAR_NO")%></a></td>
                             
                            </tr>
                          <%		}%>
			         <%} else  {%>  
				           	<tr>
								<td class='center content_border'>등록된 데이타가 없습니다</td>
						    </tr>	              
				     <%}	%>
						</table>
	          	 	</div>            
		  		</td>
		  		
		  	    <td>			
		      	 <div>
					<table class="inner_top_table table_layout">   	   
		  		    <%	if(vt_size > 0) {%>	
                	    <%for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vts.elementAt(i);    %>
                            <tr style="height: 25px;"> 
                                <td width='170' class='center content_border'><span title='<%=ht.get("CAR_NM")%> <%=ht.get("CAR_NAME")%>'>&nbsp;<%=AddUtil.substringbdot(String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME")),16)%></span></td> 
								<td width='50' class='center content_border'>
						                  <%if(!String.valueOf(ht.get("PIC_CNT")).equals("0")){%>
				                		    <a class=index1 href="javascript:MM_openBrWindow('/acar/secondhand_hp/bigimg.jsp?c_id=<%=ht.get("CAR_MNG_ID")%>','popwin0','scrollbars=no,status=no,resizable=yes,width=800,height=600,left=50, top=50')" title="차량사진 크게 보기"><img src="http://fms1.amazoncar.co.kr/images/photo_s.gif" width="17" height="15" border="0"></a>
				                        	  <%}%>
								</td>				
                                <td width='60' class='center content_border' ><span title='<%=ht.get("FUEL_KD")%>'><%=AddUtil.subData(String.valueOf(ht.get("FUEL_KD")),4)%></span></td>
                                <td width='80' class='center content_border' ><span title='<%=ht.get("COLO")%>'><%=AddUtil.subData(String.valueOf(ht.get("COLO")),4)%></span></td>
                    			<td width='85' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>
								<td width='45' class='center content_border'><%=ht.get("CAR_Y_FORM")%></td>
								<td width='40' class='center content_border'><% 	if(String.valueOf(ht.get("CAR_GU")).equals("중고차")){%>○<%}%></td>
								<td width='30' class='center content_border'><%=ht.get("USE_MON")%></td>
                                <td width='60' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TODAY_DIST2")))%></td>
                                <td width='70' class='center content_border'><%=ht.get("MAX_USE_MON")%></td>
                                <td width='60' class='right content_border'>
								                  <%if(String.valueOf(ht.get("RB12")).equals("0") || String.valueOf(ht.get("RB12")).equals("-1")){%>
								                  <center>-</center>
								                  <%}else{%>
								                  <%=AddUtil.parseDecimal(String.valueOf(ht.get("RB12")))%>
								                  <%}%>
                                </td>
                                <td width='60' class='right content_border'>
								                  <%if(String.valueOf(ht.get("RB24")).equals("0") || String.valueOf(ht.get("RB24")).equals("-1")){%>
								                  <center>-</center>
								                  <%}else{%>
								                  <%=AddUtil.parseDecimal(String.valueOf(ht.get("RB24")))%>
								                  <%}%>
                                </td>
                                <td width='60' class='right content_border'>
								                  <%if(String.valueOf(ht.get("RB36")).equals("0") || String.valueOf(ht.get("RB36")).equals("-1")){%>
								                  <center>-</center>
								                  <%}else{%>
								                  <%=AddUtil.parseDecimal(String.valueOf(ht.get("RB36")))%>
								                  <%}%>
                                </td>
                                <td width='60' class='right content_border'>
								                  <%if(String.valueOf(ht.get("LB36")).equals("0") || String.valueOf(ht.get("LB36")).equals("-1")){%>
								                  <center>-</center>
								                  <%}else{%>
								                  <%=AddUtil.parseDecimal(String.valueOf(ht.get("LB36")))%>
								                  <%}%>
                                </td>
                                <td width='70' class='center content_border'><a href="javascript:parking_car('<%=ht.get("CAR_MNG_ID")%>', '1', '<%=ht.get("PARK_ID")%>' )" onMouseOver="window.status=''; return true"><span title='<%=ht.get("PARK_NM")%><%=ht.get("AREA")%>'><%=AddUtil.subData(String.valueOf(ht.get("PARK_NM"))+""+String.valueOf(ht.get("AREA")), 4)%></span></a></td>                                
                                <td width='30' class='center content_border'><%=ht.get("ACCID_YN")%></td>	
                                <td width='80' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("ACCID_SERV_AMT1")))%></td>
                                <td width='75' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("ACCID_SERV_AMT2")))%></td>
                                <td width='60' class='center content_border'><%if(!String.valueOf(ht.get("ACCID_ID")).equals("")){ %><a href="javascript:accid_pic('<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("ACCID_ID")%>' )" onMouseOver="window.status=''; return true"><img src="http://fms1.amazoncar.co.kr/images/photo_s.gif" width="17" height="15" border="0"></a><%}%></td>
                                <td width='150' class='center content_border' ><span title='<%=ht.get("OPT")%>'> <%=AddUtil.subData(String.valueOf(ht.get("OPT")), 10)%></span></td>
                                <td width='85' class='center content_border' ><%if(!String.valueOf(ht.get("PIC_CNT")).equals("0")){%><%=ht.get("PIC_REG_DT")%><%}%></td>
                                <td width='85' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("SECONDHAND_DT")))%></td>
                    		    <td width='85' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("UPLOAD_DT")))%></td>
                    		    <td width='80' class='center content_border'><%=ht.get("JG_CODE")%></td>
                            </tr>
                       <%		}	%> 		
		      <%} else  {%>  
				       	<tr>
					       <td width="1730" colspan="24" class='center content_border'>&nbsp;</td>
					     </tr>	              
			   <%}	%>
				    </table>
			  </div>
			</td>
  		</tr>
		</table>
	</div>
</div>
</form>
</body>
</html>