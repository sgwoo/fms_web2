<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.im_email.*, acar.cont.*, acar.client.*, acar.user_mng.*,acar.common.*, acar.insur.*,acar.doc_settle.*" %>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          	scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="ImEmailDb" class="acar.im_email.ImEmailDatabase" 	scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	InsDatabase ins_db = InsDatabase.getInstance();
		
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String ins_doc_no   = request.getParameter("ins_doc_no")==null?"":request.getParameter("ins_doc_no");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String com_emp_yn = request.getParameter("com_emp_yn")==null?"":request.getParameter("com_emp_yn");
	
	String content_code = "LC_SCAN";
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);

	
	Vector client_vt = new Vector();
	client_vt = ins_db.getIjwListmailing2(base.getClient_id(), base.getCar_mng_id(), com_emp_yn);		
	
	int client_vt_size = client_vt.size();		
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//보험변경
	InsurChangeBean cng_doc = ins_db.getInsChangeDoc(ins_doc_no);
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	//발신자 사용자 정보 조회
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	String user_id = user_bean.getUser_id();
	
 	int scan_cnt = 0;
	String file_seq="";
	String savefile="";
	String add_content ="";
	String add_fileinfo	= "";
	
	Vector attach_vt = new Vector();
	int attach_vt_size = 0;	
	
	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "22", 0);
	attach_vt_size = attach_vt.size();
	
	
	
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>업무 전용 자동차 보험 가입 요청서</title>
<style type="text/css">
<!--
.style1 {color: #373737}
.style2 {color: #333333; line-height:19px;}
.style3 {color: #ff8004}
.style4 {color: #a74073; font-weight: bold;font-size:14px;}
.style5 {color: #c39235}
.style6 {color: #8b8063;}
.style7 {color: #77786b}
.style8 {color: #e60011}
.style9 {color: #707166; font-weight: bold;}
.style10 {color: #454545; font-size:8pt;}
.style11 {color: #6b930f; font-size:8pt;}
.style12 {color: #77786b; font-size:8pt;}
.style14 {color: #af2f98; font-size:8pt;}
body{
font-family:nanumgothic
}


-->
</style>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>

<script language="JavaScript">
<!--	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
//-->
</script>
</head>
<body topmargin=0 leftmargin=0>
<table width=740 border=0 cellspacing=0 cellpadding=0 align=center   
	style="border: 1px solid lightgreen;
	border-radius: 1em; border-top-left-radius: 1em;
	border-top-right-radius: 1em; border-bottom-left-radius: 1em; 
	border-bottom-right-radius: 1em;">
    <tr>
        <td height=20></td>
    </tr>
    <tr>
<!--         <td><img src=https://fms5.amazoncar.co.kr/mailing/ins/images/layout_top_ins_file3.jpg></td> -->
<!--         <td><img src=https://fms5.amazoncar.co.kr/mailing/ins/images/layout_top_ins_file4.gif style="width:100%;"></td> -->
        <td style="font-family:nanumgothic;font-size:17px;">&nbsp;&nbsp;&nbsp;<b>계약사항 변경요청서</b></td>
       
    </tr>
     <tr>
        <td height=20></td>
    </tr>
<!--     <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr> -->
    <tr>
        <td align=center>
            <table width=676 border=0 cellspacing=0 cellpadding=0 >
                <tr>
                    <td width=20>&nbsp;</td>
                    <td width=500 height=35 align="left" style="font-family:nanumgothic;font-size:12px;"><b><%=client.getFirm_nm()%> </b>님</td>
                    <td width=60 align="center">
                    <div    style="font-family:nanumgothic;font-size:10px; 
                    		background-color:lightblue; height: 12px; padding-top: 2px;
                    		border-radius: 1em; border-top-left-radius: 1em;
							border-top-right-radius: 1em; border-bottom-left-radius: 1em; 
							border-bottom-right-radius: 1em;"">
                     <b>담당자</b></div></td>
                    <td width=221 align="left" style="font-family:nanumgothic;font-size:12px;">&nbsp;&nbsp;<%if(user_bean.getUser_nm().equals("권웅철")){%>유재석<%}else{%><%=user_bean.getUser_nm()%><%}%>&nbsp;&nbsp;<%=user_bean.getUser_m_tel()%> </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align=center background="">
            <table width=676 border=0 cellspacing=0 cellpadding=0 
            style="background-color: aliceblue;
            border-radius: 1em; border-top-left-radius: 1em;
			border-top-right-radius: 1em; border-bottom-left-radius: 1em; 
			border-bottom-right-radius: 1em;"
            ">
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
                    <td width=20>&nbsp;</td>
                    <td width=670 align=center>
                        <table width=100% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=10></td>
                            </tr>
                            <tr>
                            	<td style="font-family:nanumgothic;font-size:13px;">
                            	<p>해당 차량에 대한 계약 변경이 있어 요청드립니다.</p>
                            </tr>
                            <tr>
                                <td height=15></td>
                            </tr>
                           
                            <tr>
                            </tr>
                            <tr>
                                <td height=15></td>
                            </tr>
                            <tr>
                                <td height=18 align="left" style="font-family:nanumgothic;font-size:13px;">아마존카를 이용해 주셔서 진심으로 감사드리며, 궁금하신 사항이 있으시면 담당자에게 전화주시기 바랍니다.</td>
                            </tr>
                        </table>
                    </td>
                    <td width=20>&nbsp;</td>
                </tr>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
                    <td colspan=3></td>
                </tr>
            </table>
        </td>
    </tr>

    <tr>
        <td height=30 align=center ></td>
    </tr>
    <tr>
        <td align=center>
            <table width=656 border=0 cellspacing=0 cellpadding=0>
                
                <tr>
                    <td height=20></td>
                </tr>
                <tr>
                    <td align="left">
                    <div 
                    style="width:120px;height:22px;padding-top:5px;margin-left:15px;
                    		text-align:center;
                    		font-size:12px;background-color:slategray;color:white; 
                    		border-radius: 1em; border-top-left-radius: 1em;
							border-top-right-radius: 1em; border-bottom-left-radius: 1em; 
							border-bottom-right-radius: 1em;">
                    		<b>계약사항 변경차량</b></div></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td align=center>
                        <table width=690 border=0 cellspacing=1 cellpadding=0 bgcolor=d6d6d6>
	                        <tr>
	                        	<td height=2 bgcolor=656e7f colspan=4></td>
	                        </tr>
                            <tr>
                                <!-- <td bgcolor=f2f2f2 height=40 width=15% align=center style="font-family:nanumgothic;font-size:12px;">기존 보험<br>만료일</td> -->
                                <td bgcolor=f2f2f2 width=35% height=40 align=center style="font-family:nanumgothic;font-size:12px;">차종</td>
                                <td bgcolor=f2f2f2 width=25% align=center style="font-family:nanumgothic;font-size:12px;">차량번호</td>
                              <!--   <td bgcolor=f2f2f2 width=25% align=center style="font-family:nanumgothic;font-size:12px;">업무 전용보험<br>가입대상차종 여부</td> -->
                            </tr>
                		  	<%														
							for(int k=0;k<client_vt_size;k++){
							
        							  Hashtable ht = (Hashtable)client_vt.elementAt(k);
        							          						  
 					%>
        						 <tr bgcolor=#ffffff>
        						 		<%-- <td height=40 align=center style="font-family:nanumgothic;font-size:12px;"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INS_EXP_DT")))%></td> --%>
											<td height=40 align=center style="font-family:nanumgothic;font-size:12px;"><%=ht.get("CAR_NM")%>&nbsp;<%=ht.get("CAR_NAME")%></td>
											<td align=center style="font-family:nanumgothic;font-size:12px;color:#a74073;"><%=ht.get("CAR_NO")%></td>
										<%-- 	<td align=center style="font-family:nanumgothic;font-size:12px;"><%=ht.get("COM_EMP_YN")%></td> --%>
										 </tr>
										<% }%>                       
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td height=35></td>
                </tr>
                
              <%  if(attach_vt_size > 0){
					for (int j = 0 ; j < attach_vt_size ; j++){
						Hashtable ht = (Hashtable)attach_vt.elementAt(j);    
						
						//등록일과 완료일 사이의 스캔만 가져온다.	
						if(AddUtil.parseInt(cng_doc.getReg_dt()) > AddUtil.parseInt(String.valueOf(ht.get("REG_DT")))) continue; 	
						
						if(!doc.getVar01().equals("") && AddUtil.parseInt(doc.getVar01()) < AddUtil.parseInt(String.valueOf(ht.get("REG_DT")))) continue; 
						
						scan_cnt++;							
						file_seq = String.valueOf(ht.get("SEQ"));
						savefile = String.valueOf(ht.get("SAVE_FILE")).substring(String.valueOf(ht.get("SAVE_FILE")).lastIndexOf(".") + 1);
						add_fileinfo 	= "계약사항변경요청서."+savefile;
						add_content 	= "https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp?SEQ="+file_seq;
						
				%>
				 <tr>
                	<td align=center><a href=<%=add_content%> target="_blank" style="text-decoration: none;">
						<div class="radius-border" 
						style="background-color:mediumvioletred;color:white;height:28px;width:320px; 
						padding-top:7px; box-shadow: 0px 4px 6px 0px grey;
						border-radius: 1em; border-top-left-radius: 1em;
						border-top-right-radius: 1em; border-bottom-left-radius: 1em; 
						border-bottom-right-radius: 1em;
						">
						<b>변경된 계약 내용 확인하기</b></div>
                	</a></td>
                </tr>				
				
				<%
					}		
				}  
				%>
                
               
                 
                <tr>
                    <td height=20></td>
                </tr>

				<tr>
					<td height=30></td>
				</tr>                
            </table>
        </td>
    </tr>
    
<!--     <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif<img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr> -->
  <!--   <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr> -->
    <!-- <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=35>&nbsp;</td>
                    <td width=85><img src=http://fms1.amazoncar.co.kr/acar/images/logo_1.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=493><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
                </tr>
                <map name=Map1>
                    <area shape=rect coords=283,53,403,67 href=mailto:tax@amazoncar.co.kr>
                </map>
            </table>
        </td>
    </tr> -->
  <!--   <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_bottom.gif width=700 height=21></td>
    </tr> -->
</table>
</body>
</html>