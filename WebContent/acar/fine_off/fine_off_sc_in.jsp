<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.common.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");//로그인-영업소
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")		==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	
	int sh_height 	= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	//chrome 관련 
	String height 	= request.getParameter("height")		==null?"":request.getParameter("height");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	
	Vector vt = a_fdb.getFineOffList(s_kd, t_wd, gubun1, gubun2, st_dt, end_dt, "");
	int vt_size = vt.size();
	String param = "";
	
%>

<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript" src="/include/table_fix.js?ver=0.2"></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css?ver=0.2">
<link rel="stylesheet" type="text/css" href="/include/table_fix.css?ver=0.2">

<script language="JavaScript">
	//스캔등록
	function scan_reg(file_st, m_id, l_cd, c_id, seq_no){
		window.open("../fine_mng/reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&seq_no="+seq_no+"&file_st="+file_st, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//수정팝업
	function go_pop(car_no, m_id, l_cd, c_id, seq_no){
		window.open("../fine_mng/fine_mng_sc.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&seq_no="+seq_no+"&s_kd=4&t_wd="+car_no+"&f_list=out", "SCAN", "left=10, top=10, width=900, height=800, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//납부일자 등록/수정 팝업
	function reg_proxy_dt(m_id, l_cd, c_id, seq_no, proxy_dt){
		window.open("fine_off_pop.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&seq_no="+seq_no+"&gubun=proxy_dt&proxy_dt="+proxy_dt, "SCAN", "left=10, top=10, width=450, height=200, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//위반내용보기
	function view_fineCont(m_id, l_cd, c_id, seq_no){
		window.open("fine_off_pop.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&seq_no="+seq_no+"&gubun=view_fine", "SCAN", "left=10, top=10, width=600, height=200, scrollbars=yes, status=yes, resizable=yes");
	}
	
	function send_msg(){
		var param = $("#param").val();
		if(param==null){
			alert("아직 페이지가 모두 로딩되지않았습니다.");	return; 
		}
		if(confirm("아래 협력업체 중 메세지송신이 가능한 업체 모두에 납부요청 메세지를 발송합니다.\n\n"+param+"\n\n(발송대상에서 제외하려면 납부일자를 입력해 완료처리하세요)\n\n메세지를 전송하시겠습니까?")){
			window.open("fine_off_pop_a.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&param="+param+"&gubun=send_msg", "SCAN", "left=10, top=10, width=600, height=200, scrollbars=yes, status=yes, resizable=yes");
		}
	}
	
</script>
</head>

<body>
<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='height' id="height" value='<%=height%>'>

<div class="tb_wrap" >
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 1950px;">
					<div style="width: 1950px;">
						<table class="inner_top_table table_layout" style="height: 60px;">
						 <colgroup>
			             	<col width="50">
			       			<col width="120">
			       			<col width="80">
			       			<col width="70">
			       			<col width="80">		       			
			       			<col width="120"> 
			       			<col width="250"> 
			       			<col width="250"> 
			       					       		
			       			<col width="110">
			       			<col width="80">			       			
			       			<col width="300">
			       			<col width="60">
			       			<col width="80">			       				       			
			       			<col width="300">	
			       		</colgroup>
	       		      
						<tr>
                        	<td width=50  class='title title_border' rowspan="2">연번</td>
							<td width=120 class='title title_border' rowspan="2">협력업체<br>(탁송사)</td>
		            		<td width=80  class='title title_border' rowspan="2">탁송의뢰일</td>
		            		<td width=70  class='title title_border' rowspan="2">의뢰자</td>
							<td width=80  class='title title_border' rowspan="2">차량번호</td>
							<td width=120 class='title title_border' rowspan="2">차명</td>
							<td width=250 class='title title_border' rowspan="2">출발지</td>
							<td width=250 class='title title_border' rowspan="2">도착지</td>
							<td width=840 class='title title_border' colspan="6">과태료</td>		  
		        	    </tr>
		        	    <tr>
			        		<td width=110 class='title title_border'>위반일시</td>
		            		<td width=80  class='title title_border'>납부요청일</td>
		            		<td width=300 class='title title_border'>납부고지서</td>
		            		<td width=60  class='title title_border'>위반내용</td>
		            		<td width=80  class='title title_border'>납부일자</td>
		            		<td width=300 class='title title_border'>납입영수증</td>          
		        	    </tr>
					</table>
				</div>
			  </td>
			</tr>
		</table>
	</div>
	
	<div class="tb_box">
		<table class="tb" >
			<tr>
				<td style="width: 1950px;">
				  <div style="width: 1950px;">
					<table class="inner_top_table table_layout">	

            			<%
            				if(vt_size >0){
            					for(int i=0; i<vt_size; i++){
            						Hashtable ht = (Hashtable)vt.elementAt(i);
            						String rent_l_cd 		= String.valueOf(ht.get("RENT_L_CD"));
            						String rent_mng_id 	= String.valueOf(ht.get("RENT_MNG_ID"));
            						String car_mng_id 	= String.valueOf(ht.get("CAR_MNG_ID"));
            						String seq_no 			= String.valueOf(ht.get("SEQ_NO"));
            						String vio_dt 			= String.valueOf(ht.get("VIO_DT"));
            						
            						Vector vt2 = a_fdb.getFineOffConsList(rent_l_cd, rent_mng_id, vio_dt);
            						Hashtable ht2 = new Hashtable();
            						int vt2_size = vt2.size();
            						if(vt2_size==1){
            							ht2 = (Hashtable)vt2.elementAt(0);	
            						}
            						
            						String content_code = "FINE";
            						String content_seq  = rent_mng_id+rent_l_cd+car_mng_id+seq_no;
            						Vector attach_vt = null;
            						int attach_vt_size = 0;
            						
            						if(!rent_mng_id.equals("")&&!rent_l_cd.equals("")&&!car_mng_id.equals("")&&!seq_no.equals("")){
            							attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
            							attach_vt_size = attach_vt.size();
            						}
            						
            						String file_type1 = "";
            						String seq1 = "";
            						String file_type2 = "";
            						String seq2 = "";
            						String file_name1 = "";
            						String file_name2 = "";
            						
            						if(attach_vt_size >0){
            							for(int j=0; j< attach_vt.size(); j++){
            						    	Hashtable ht3 = (Hashtable)attach_vt.elementAt(j);   
            								
            								if((content_seq+1).equals(ht3.get("CONTENT_SEQ"))){
            									file_name1 = String.valueOf(ht3.get("FILE_NAME"));
            									file_type1 = String.valueOf(ht3.get("FILE_TYPE"));
            									seq1 = String.valueOf(ht3.get("SEQ"));            									
            								}else if((content_seq+2).equals(ht3.get("CONTENT_SEQ"))){
            									file_name2 = String.valueOf(ht3.get("FILE_NAME"));
            									file_type2 = String.valueOf(ht3.get("FILE_TYPE"));
            									seq2 = String.valueOf(ht3.get("SEQ"));
            								}
            							}	
            						}
            						
            						//완료건은 색 변경
            						String add_class = "";
        							if(!String.valueOf(ht.get("PROXY_DT")).equals("")){		add_class =" class=' is   content_border' "; }
        							
        							//메세지 보내기용 파라미터 세팅
        							if(String.valueOf(ht.get("PROXY_DT")).equals("") && !String.valueOf(ht.get("FAULT_NM")).equals("")){
        								String fault_nm = String.valueOf(ht.get("FAULT_NM"));
        								String [] param_arr = param.split(",");
        								for(int j=0; j<param_arr.length;j++){
        									if(param_arr[j].equals(fault_nm)){
        										fault_nm = "";
        										continue;
        									}
        								}
        								if(!fault_nm.equals("")){
        									if(param.equals("")){	param += fault_nm;			}
        									else{							param +=","+fault_nm;	}
        								}
        							}
            			%>
            				<tr style="height: 25px;"> 
								<td "<%=add_class%>" width=50 class="content_border" style="text-align:center"><%=i+1%></td>
								<td "<%=add_class%>" width=120 class="content_border" style="text-align:center"><%=ht.get("FAULT_NM")%></td>
								<%if(vt2_size==1){ %>
				            		<td "<%=add_class%>" width=80 class="content_border" style="text-align:center"><%=AddUtil.ChangeDate2(String.valueOf(ht2.get("REG_DT")))%></td>
				            		<td "<%=add_class%>" width=70 class="content_border" style="text-align:center"><%=ht2.get("USER_NM")%></td>
			            		<%}else{%>
			            			<td "<%=add_class%>" width=150 class="content_border" style="text-align:center" colspan="2"><!-- 직접확인필요 --></td>	
			            		<%}%>
								<td "<%=add_class%>" width=80 class=" content_border" style="text-align:center"><%=ht.get("CAR_NO")%></td>
								<td "<%=add_class%>" width=120 class="content_border" style="text-align:left">&nbsp;<%=ht.get("CAR_NM")%></td>
								<%if(vt2_size==1){ %>
									<td "<%=add_class%>" width=250 class="content_border" style="text-align:left">&nbsp;<%=ht2.get("FROM_PLACE")%></td>
									<td "<%=add_class%>" width=250 class="content_border" style="text-align:left">&nbsp;<%=ht2.get("TO_PLACE")%></td>
								<%}else{%>
									<td "<%=add_class%>" width=500 class="content_border" style="text-align:left" colspan="2">&nbsp;탁송 <%=vt2_size%> 건  검색됨. 직접확인필요</td>
								<%}%>
			            		<td "<%=add_class%>" width=110 class=" content_border" style="text-align:center">
			            			<a href="javascript:go_pop('<%=ht.get("CAR_NO")%>','<%=rent_mng_id%>','<%=rent_l_cd%>','<%=car_mng_id%>','<%=seq_no%>')"><%=ht.get("VIO_DT")%></a>
			            		</td>
			            		<td "<%=add_class%>" width=80 class="content_border" style="text-align:center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PAID_END_DT")))%></td>
			            		<td "<%=add_class%>" width=300 class="content_border" style="text-align:center">
			            		<%if(file_name1.equals("")){%>
							  		<a href="javascript:scan_reg('1', '<%=rent_mng_id%>', '<%=rent_l_cd%>', '<%=car_mng_id%>', '<%=seq_no%>');"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
						  		<%}else{%>
								  	<%	if(file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")||file_type1.equals("application/pdf")){%>
									 	<a href="javascript:openPopP('<%=file_type1%>','<%=seq1%>');" title='보기' ><%=file_name1%></a>
									<%	}else{%>
									 	<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq1%>" target='_blank'><%=file_name1%></a>
									<%	}%>
										&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq1%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
								<%}%>	
			            		</td>
			            		<td "<%=add_class%>" width=60 class="content_border" style="text-align:center">
			            			<a href="javascript:view_fineCont('<%=rent_mng_id%>', '<%=rent_l_cd%>', '<%=car_mng_id%>', '<%=seq_no%>');"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
			            		</td>
			            		<td "<%=add_class%>" width=80 class="content_border" style="text-align:center">
			            		<%if(String.valueOf(ht.get("PROXY_DT")).equals("")){%>
			            			<a href="javascript:reg_proxy_dt('<%=rent_mng_id%>', '<%=rent_l_cd%>', '<%=car_mng_id%>', '<%=seq_no%>','');"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
			            		<%}else{%>
			            			<a href="javascript:reg_proxy_dt('<%=rent_mng_id%>', '<%=rent_l_cd%>', '<%=car_mng_id%>', '<%=seq_no%>','<%=AddUtil.ChangeDate2(String.valueOf(ht.get("PROXY_DT")))%>');"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PROXY_DT")))%></a>
			            		<%}%>
			            		</td>
			            		<td "<%=add_class%>" width=300 class="content_border" style="text-align:center">
			            		<%if(file_name2.equals("")){%>
						  			<a href="javascript:scan_reg('2', '<%=rent_mng_id%>', '<%=rent_l_cd%>', '<%=car_mng_id%>', '<%=seq_no%>');"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
						  		<%}else{%>
						  			<%	if(file_type2.equals("image/jpeg")||file_type2.equals("image/pjpeg")||file_type2.equals("application/pdf")){%>
							 			<a href="javascript:openPopP('<%=file_type2%>','<%=seq2%>');" title='보기' ><%=file_name2%></a>
							 		<%	}else{%>
							 			<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq2%>" target='_blank'><%=file_name2%></a>
							 		<%	}%>
							 			&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq2%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
							 	<%}%>	
			            		</td>
			            	</tr>	
            			<%	}
            				}else{%>
            				<tr>
            					<td class="center content_border" width="100%">
			            			데이터가 없습니다.
            					</td>
            				</tr>
            			<%} %>	
           				</table>
           			   </div>	
            		</td>            		            		
            	</tr>
           </table>
       </div>
</div>

<input type="hidden" name="param" id="param" value="<%=param%>">
</form>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>	
</body>
</html>