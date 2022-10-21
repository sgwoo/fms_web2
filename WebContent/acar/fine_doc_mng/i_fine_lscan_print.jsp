<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.* ,acar.client.*, acar.forfeit_mng.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
	
<%
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_mng_id2 = request.getParameter("rent_mng_id2")==null?"":request.getParameter("rent_mng_id2");
	String rent_l_cd2 	= request.getParameter("rent_l_cd2")==null?"":request.getParameter("rent_l_cd2");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_s_cd 	= request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");
	String vio_dt 		= request.getParameter("vio_dt")==null?"":request.getParameter("vio_dt");
	String rent_st		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String id_card_yn	= request.getParameter("id_card_yn")==null?"":request.getParameter("id_card_yn");
	
	double img_width 	= 690;
	double img_height 	= 1009;
	
	CommonDataBase 		c_db 	= 	 CommonDataBase.getInstance();
	AddForfeitDatabase 	afm_db 	=	 AddForfeitDatabase.getInstance();
	
%>
	
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%if(mode.equals("b-lazy")){%>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/blazy@1.8.2/blazy.min.js"></script>
<%}%>
<script language='JavaScript' src='/include/common.js'></script>
<style>

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

</style>
</head>
<body leftmargin="15" topmargin="1"  >
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 

<!--계약서외 스캔파일-->
<%
				int size = 0;
				String content_seq = "";
				String save_file1 ="";
				String save_file2 ="";
				String save_file3 ="";
				String save_file4 ="";
				String save_folder1 ="";
				String save_folder2 ="";
				String save_folder3 ="";
				String save_folder4 ="";
				
				if(rent_st.equals("")){
					//대여기간에 맞는 과태료 입력 확인
					rent_st = afm_db.getFineSearchRentst(rent_mng_id, rent_l_cd, AddUtil.replace(vio_dt,"-",""));
				}
				
				if(!rent_st.equals("")){	content_seq  = rent_mng_id + rent_l_cd + rent_st;		}
				else{						content_seq  = rent_mng_id + rent_l_cd + "%";			}
				
				//계약서 스캔파일 가져오기 + 사업자등록증.
				if(!rent_s_cd.equals("")){
					if(!rent_st.equals("")){	content_seq  = rent_mng_id2 + rent_l_cd2 + rent_st;		}
					else{						content_seq  = rent_mng_id2 + rent_l_cd2 + "%";			}
				}
				
				Vector attach_vt = c_db.getAcarAttachFileLcScanClientList_fine(client_id, content_seq);
				int  attach_vt_size = attach_vt.size();
				
				//고객정보
				ClientBean client =  al_db.getNewClient(client_id);
				
				int rent_cnt = 0;
   			// tip : 계약서는 반드시 계약번호로, 사업자나 신분증은 계약번호가 아닌경우도 있음. client_id로 
				for(int y=0; y< attach_vt.size(); y++){
					Hashtable aht = (Hashtable)attach_vt.elementAt(y);
					
					boolean file4_yn = false;
					//신분증  (특정 계약번호는 대표자가 여러명이라 최근 계약건을 통해 신분증을 조회(2018.03.29), 요청시 하드코딩으로 계약번호추가VV)
					/* if(rent_l_cd.equals("G116HDHR00089") || rent_l_cd.equals("G116HGHR00025")){
						if((content_seq+"14").equals(aht.get("CONTENT_SEQ"))){
							save_file4 = String.valueOf(aht.get("SAVE_FILE"));
							save_folder4 = String.valueOf(aht.get("SAVE_FOLDER"));
							file4_yn = true;
						}
					} */
					String c_seq_text = String.valueOf(aht.get("CONTENT_SEQ"));
					
					if(Integer.parseInt(c_seq_text.substring(19,20)) >= rent_cnt){
						rent_cnt = Integer.parseInt(c_seq_text.substring(19,20));
					
						if(aht.get("RK").equals("1")){
						
							String c_seq = "";
							if(c_seq_text.length() > 21){
								if(!rent_st.equals("")){	c_seq = c_seq_text.substring(0,19)+ rent_st + c_seq_text.substring(20,22);		}
								else{						c_seq = c_seq_text.substring(0,19)+"%"+c_seq_text.substring(20,22);				}
							}
							if((content_seq+"17").equals(c_seq)){
								save_file1 = String.valueOf(aht.get("SAVE_FILE"));
								save_folder1 = String.valueOf(aht.get("SAVE_FOLDER"));
							}
							if((content_seq+"18").equals(c_seq)){
								save_file2 = String.valueOf(aht.get("SAVE_FILE"));
								save_folder2 = String.valueOf(aht.get("SAVE_FOLDER"));
							}
							if(client.getClient_st().equals("2") || client.getClient_st().equals("3")||
							   client.getClient_st().equals("4") || client.getClient_st().equals("5")){
								if((content_seq+"27").equals(c_seq)){
									save_file4 = String.valueOf(aht.get("SAVE_FILE"));
									save_folder4 = String.valueOf(aht.get("SAVE_FOLDER"));
								}	
							}
	   					}
					}
					if(aht.get("RK").equals("1")){
						if(String.valueOf( aht.get("CONTENT_SEQ")).length()==21 
								&& String.valueOf( aht.get("CONTENT_SEQ")).substring(20,21).equals("2")){
							save_file3 = String.valueOf(aht.get("SAVE_FILE"));
							save_folder3 = String.valueOf(aht.get("SAVE_FOLDER"));
						}
						if(save_file3.equals("")){
								if( String.valueOf(aht.get("CONTENT_SEQ")).substring(20,21).equals("4")){
								save_file3 = String.valueOf(aht.get("SAVE_FILE"));
								save_folder3 = String.valueOf(aht.get("SAVE_FOLDER"));
							}
						}
						/* if(file4_yn == false){
							if(!client.getClient_st().equals("1") && !client.getClient_st().equals("2")){
							 	if( String.valueOf(aht.get("CONTENT_SEQ")).substring(20,21).equals("4")){
									save_file4 = String.valueOf(aht.get("SAVE_FILE"));
									save_folder4 = String.valueOf(aht.get("SAVE_FOLDER"));
							 	}	
							}	
						} */
   					}
				}
%>		
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" class="a4">
	<tr valign="top">
		<td>
			<%if(mode.equals("b-lazy")){%>
				<%if(!save_file1.equals("")){ %>
					<div style="position: relative;">
						<img class="b-lazy" data-src="https://fms3.amazoncar.co.kr<%=save_folder1%><%=save_file1%>" width=<%=img_width%> height=<%=img_height%> style="z-index: 1;">
						<img src="/acar/images/stamp_c.png" style="position:absolute; z-index: 2; left:50px; top: 950px; width: 170px;">
					</div>	
					<br style="page-break-before:always;">
				<% } %>
				<%if(!save_file2.equals("")){ %>
					<div style="position: relative;">
						<img class="b-lazy" data-src="https://fms3.amazoncar.co.kr<%=save_folder2%><%=save_file2%>" width=<%=img_width%> height=<%=img_height%> style="z-index: 1;">
						<img src="/acar/images/stamp_c.png" style="position:absolute; z-index: 2; left:50px; top: 950px; width: 170px;">
					</div>	
					<br style="page-break-before:always;">
				<% } %>
				<%if(!save_file3.equals("")){ %> 
					<img class="b-lazy" data-src="https://fms3.amazoncar.co.kr<%=save_folder3%><%=save_file3%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
				<%}%>
				<%if(!save_file4.equals("")){ %> 
					<img class="b-lazy" data-src="https://fms3.amazoncar.co.kr<%=save_folder4%><%=save_file4%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
				<%}%>
			<%}else{ %>
				<%if(!save_file1.equals("")){ %>
					<div style="position: relative;">
						<img src="https://fms3.amazoncar.co.kr<%=save_folder1%><%=save_file1%>" width=<%=img_width%> height=<%=img_height%> style="z-index: 1;">
						<img src="/acar/images/stamp_c.png" style="position:absolute; z-index: 2; left:50px; top: 950px; width: 170px;">
					</div>	
					<br style="page-break-before:always;">
				<% } %>
				<%if(!save_file2.equals("")){ %>
					<div style="position: relative;">
						<img src="https://fms3.amazoncar.co.kr<%=save_folder2%><%=save_file2%>" width=<%=img_width%> height=<%=img_height%> style="z-index: 1;">
						<img src="/acar/images/stamp_c.png" style="position:absolute; z-index: 2; left:50px; top: 950px; width: 170px;">
					</div>	
					<br style="page-break-before:always;">
				<% } %>
				<%if(save_file1.equals("") || save_file2.equals("")){ %>
					<%if(rent_s_cd.equals("")){ //아마존카 보유차량이 아니면 문구보여줌%>
						<div style="text-align: center; padding-top: 1000px;">
							<div style="font-size: 30px;">계약서 
							<%if(save_file1.equals("")){%>전면 <%}%><%if(save_file2.equals("")){%>후면 <%}%>이 출력되지 않았습니다.  
							</div>
						</div>
						<br style="page-break-before:always;">
					<%}%>
				<%} %>
				<%if(!save_file3.equals("")){ %> 
					<img src="https://fms3.amazoncar.co.kr<%=save_folder3%><%=save_file3%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
				<%}%>
				<%if(!save_file4.equals("")){ %> 
					<img src="https://fms3.amazoncar.co.kr<%=save_folder4%><%=save_file4%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
				<% } %>
			<%}%>
		</td>
	</tr>
</table>

<%if(mode.equals("b-lazy")){%>
<script>
    var bLazy = new Blazy({ });
</script>
<%}%>

</body>
</html>
