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
	

	CommonDataBase c_db = CommonDataBase.getInstance();
	


	
	if(!gubun_nm.equals("")) gubun_nm = AddUtil.replace(gubun_nm,"'","");
	
	
	Vector vts = shDb.getSecondhandList_RM(gubun2, gubun, gubun_nm, brch_id, sort_gubun, res_yn, res_mon_yn, all_car_yn);
	int vt_size = vts.size();
	
	
	long total_c_amt = 0;
	long total_f_amt = 0;
	long total_rb_amt = 0;
	long total_lb_amt = 0;
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}
	
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
	
-->
</script>
</head>
<body onLoad="javascript:init()">
<form name="form1">
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
  <table border=0 cellspacing=0 cellpadding=0 width="1515">
    <tr>
      <td>
        <table border="0" cellspacing="0" cellpadding="0" width="100%">
          <tr>
            <td class=line2 colspan=2></td>
          </tr>
	        <tr id='tr_title' style='position:relative;z-index:1'>
            <td width="660" class='line' id='td_title' style='position:relative;'>
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td width='25' class='title' rowspan="2"> <input type="checkbox" name="all_pr" value="Y" onclick='javascript:AllSelect(this.form.pr)'></td>
                  <td width='25' class='title' rowspan="2">연번</td>
                  <td width='105' class='title' rowspan="2">내용</td>
                  <td class='title' colspan="4">예약</td>
								  <td class='title' width="50" rowspan="2">상태</td>
                  <td width='80' class='title' rowspan="2">차량번호</td>
                  <td width='160' class='title' rowspan="2">차명</td>
                </tr>
                <tr> 
                  <td class='title' width="55">상태</td>
                  <td class='title' width="80">1순위</td>
                  <td class='title' width="40">2순위</td>
                  <td class='title' width='40'>3순위</td>
                </tr>
              </table>
            </td>
    		    <td class='line' width="855"> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
								  <td width='30' class='title' rowspan="2">사진</td>
                  <td width='70' class='title' rowspan="2">연료</td>
                  <td width='70' class='title' rowspan="2">색상</td>
								  <td width='80' class='title' rowspan="2">최초<br>등록일</td>
								  <td width='25' class='title' rowspan="2">차령</td>
                  <td width='50' class='title' rowspan="2">주행<br>거리</td>
                  <td class='title' colspan="2">월렌트</td>
                  <td width='60' class='title' rowspan="2">주차장</td>
                  <td width='30' class='title' rowspan="2">사고<br>유무</td>
                  <td width='70' class='title' rowspan="2">사진<br>등록일자</td>
                  <td width='150' class='title' rowspan="2">선택사양</td>
                  <td width='80' class='title' rowspan="2">대여료<br>수정일</td>
                </tr>
                <tr> 
                  <td class='title' width="65">공급가</td>
                  <td class='title' width="65">VAT포함</td>
                </tr>
              </table>
 		        </td>
	        </tr>
          <%	if(vt_size > 0){%>
	        <tr>
            <td width="660" class='line' id='td_con' style='position:relative;'> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                <%for(int i = 0 ; i < vt_size ; i++){
				       			Hashtable ht = (Hashtable)vts.elementAt(i);
								%>
                <tr>
                  <td width='25' align='center'><input type="checkbox" name="pr" value="<%=ht.get("CAR_MNG_ID")%>"></td>
                  <td width='25' align='center'><%=i+1%></td>
                  <td width='105' align='center'>
								    <% if(!String.valueOf(ht.get("ACTN_ST")).equals("")){ 
												//경매정보
												Hashtable ht_apprsl 	= shDb.getCarApprsl(String.valueOf(ht.get("CAR_MNG_ID")));
										%>
										<font color=green>	
										<% if(String.valueOf(ht.get("ACTN_ST")).equals("유찰")){ %>
                      <span title='[<%=ht.get("ACTN_ST")%>] 경매장:<%=ht_apprsl.get("FIRM_NM")%>, 평가일자:<%=AddUtil.ChangeDate2(String.valueOf(ht_apprsl.get("APPRSL_DT")))%>, 경매일자:<%=ht.get("ACTN_DT")%>, 다음경매예정일:<%=ht.get("ACTN_EST_DT")%>'>경매:<%=ht.get("ACTN_EST_DT")%> </span>
										<% }else{%>
                      <span title='[<%=ht.get("ACTN_ST")%>] 경매장:<%=ht_apprsl.get("FIRM_NM")%>, 평가일자:<%=AddUtil.ChangeDate2(String.valueOf(ht_apprsl.get("APPRSL_DT")))%>, 경매일자:<%=ht.get("ACTN_DT")%> <%if(String.valueOf(ht.get("RENT_ST")).equals("네고중")){ %> ( <%=ht.get("SITU_NM")%>)  <%} %> '><%=ht.get("RENT_ST")%></span>
										<% }%>
										</font>
								    <%}else{%>
										<% 	if(String.valueOf(ht.get("RENT_ST")).equals("대기")){ %>
										<%=ht.get("RENT_ST")%><font color='#999999'><span title='<%=ht.get("PARK_CONT")%>'>(<%=AddUtil.subData(String.valueOf(ht.get("PARK")),4)%>)</span></font>
										<% 	}else if(String.valueOf(ht.get("RENT_ST")).equals("매각결정")){ %>
										<font color="red"><%=ht.get("RENT_ST")%></font>
										<%	}else{%>
										<span title='[<%=ht.get("RENT_ST")%>] 반차예정일:<%=ht.get("RET_PLAN_DT")%>'><%if(String.valueOf(ht.get("RENT_ST")).equals("월렌트")){%><font color="red"><%=ht.get("RENT_ST")%></font><%}else{%><%=ht.get("RENT_ST")%><%}%><font color='#999999'><%=AddUtil.ChangeDate(String.valueOf(ht.get("RET_PLAN_DT")),"MM/DD")%></font></span> 
										<%	}%>
                    <% } %>
                  </td>
                  <td width='55' align='center'><%=ht.get("SITUATION")%></td>
                  <td width='80' align='center'>
	                  <font color="#FF66FF"><span title='<%=ht.get("MEMO")%> 예약기간:<%=ht.get("RES_ST_DT")%>~<%=ht.get("RES_END_DT")%>'><%=ht.get("SITU_NM")%><%=AddUtil.ChangeDate(String.valueOf(ht.get("RES_END_DT")),"MM/DD")%></span></font> 
                  </td>
									<%if(String.valueOf(ht.get("RES_CNT")).equals("1")||String.valueOf(ht.get("RES_CNT")).equals("2")){ 
											Vector sr = shDb.getShResList(String.valueOf(ht.get("CAR_MNG_ID")));
											int sr_size = sr.size();
											if(sr_size >3) sr_size=3;
											for(int j = 1 ; j < sr_size ; j++){
												Hashtable sr_ht = (Hashtable)sr.elementAt(j);
									%>
                  <td width='40' align='center'><%=c_db.getNameById(String.valueOf(sr_ht.get("DAMDANG_ID")),"USER")%></td>
									<%		}%>
									<%		if(sr_size==2){%>
                  <td width='40' align='center'>&nbsp;</td>
									<%		}%>
									<%		if(sr_size==1){%>
                  <td width='40' align='center'>&nbsp;</td>
                  <td width='40' align='center'>&nbsp;</td>
									<%		}%>
									<%}else{%>
                  <td width='40' align='center'>&nbsp;</td>
                  <td width='40' align='center'>&nbsp;</td>
								  <%}%>
								  <td width='50' align='center'><span title='<%=ht.get("RM_CONT")%>'><%if(String.valueOf(ht.get("RM_ST")).equals("정비요")){%><font color=red><%}%><%=ht.get("RM_ST")%><%if(String.valueOf(ht.get("RM_ST")).equals("정비요")){%></font><%}%></span></td>
                  <td width='80' align='center'><a href="javascript:parent.view_detail('<%=auth_rw%>','<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("JG_CODE")%>')"><%=ht.get("CAR_NO")%></a></td>
                  <td width='160'><span title='<%=ht.get("CAR_NM")%> <%=ht.get("CAR_NAME")%>'>&nbsp;<%=AddUtil.substringbdot(String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME")),20)%></span></td>
                </tr>
                <%}%>
              </table>
            </td>
            <td class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width="855" >
                <%for(int i = 0 ; i < vt_size ; i++){
										Hashtable ht = (Hashtable)vts.elementAt(i);
			    			%>
                <tr> 
				          <td width='30' align='center'>
		                <%if(!String.valueOf(ht.get("PIC_CNT")).equals("0")){%>
                	  <a class=index1 href="javascript:MM_openBrWindow('/acar/secondhand_hp/bigimg.jsp?c_id=<%=ht.get("CAR_MNG_ID")%>','popwin0','scrollbars=no,status=no,resizable=yes,width=800,height=600,left=50, top=50')" title="차량사진 크게 보기"><img src="http://fms1.amazoncar.co.kr/images/photo_s.gif" width="17" height="15" border="0"></a>
                    <%}%>
				          </td>
                  <td width='70' align='center' ><span title='<%=ht.get("FUEL_KD")%>'><%=AddUtil.subData(String.valueOf(ht.get("FUEL_KD")),4)%></span></td>
                  <td width='70' align='center' ><span title='<%=ht.get("COLO")%>'><%=AddUtil.subData(String.valueOf(ht.get("COLO")),4)%></span></td>
                  <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>
								  <td width='25' align='center'><%=ht.get("USE_MON")%></td>
                  <td width='50' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TODAY_DIST2")))%></td>
                  <td width='65' align='right'>
                   	<%if(String.valueOf(ht.get("RM1")).equals("0") || String.valueOf(ht.get("RM1")).equals("-1")){%>
								    <center>-</center>
								    <%}else{%>
								    <%=AddUtil.parseDecimal(String.valueOf(ht.get("RM1")))%>
								    <%}%>
								  </td>
				          <td width='65' align='right'>
				            <%if(String.valueOf(ht.get("RM1_SV")).equals("0") || String.valueOf(ht.get("RM1_SV")).equals("-1")){%>
								    <center>-</center>
								    <%}else{%>
								    <%=AddUtil.parseDecimal(String.valueOf(ht.get("RM1_SV")))%>
								    <%}%>
								  </td>
                  <td width='60' align='center'><a href="javascript:parking_car('<%=ht.get("CAR_MNG_ID")%>', '1', '<%=ht.get("PARK_ID")%>' )" onMouseOver="window.status=''; return true"><span title='<%=ht.get("PARK_NM")%><%=ht.get("AREA")%>'><%=AddUtil.subData(String.valueOf(ht.get("PARK_NM"))+""+String.valueOf(ht.get("AREA")), 4)%></span></a></td>
                  <td width='30' align='center'><%=ht.get("ACCID_YN")%></td>	
                  <td width='70' align='center' ><%if(!String.valueOf(ht.get("PIC_CNT")).equals("0")){%><%=ht.get("PIC_REG_DT")%><%}%></td>
                  <td width='150' align='center' ><span title='<%=ht.get("OPT")%>'> <%=AddUtil.subData(String.valueOf(ht.get("OPT")), 10)%></span></td>                  
								  <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("UPLOAD_DT")))%></td>
                </tr>
                <%			
                	}
                %>
              </table>
		        </td>
	        </tr>
          <%}else{%>
	        <tr>
	          <td class='line' id='td_con' style='position:relative;'> 
	            <table border="0" cellspacing="1" cellpadding="0" width="660" >
                <tr> 
                  <td align='center'></td>
                </tr>
              </table>
            </td>
	          <td class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width="855" >
                <tr> 
                  <td  align='left' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;해당 예비차량이 없읍니다.</td>
                </tr>
              </table>
		        </td>
	        </tr>
          <%}%>
        </table>
      </td>
    </tr>
  </table>
</form>
</body>
</html>