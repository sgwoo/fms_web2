<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="p_bean" class="acar.off_anc.PropBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	int prize =0;
	
	
	OffPropDatabase p_db = OffPropDatabase.getInstance();
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&asc="+asc+"&gubun1="+gubun1+"&gubun2="+gubun2+
					"&st_dt="+st_dt+"&end_dt="+end_dt;
	
	
	
	int prop_id = request.getParameter("prop_id")==null?0:Util.parseInt(request.getParameter("prop_id"));
	
	int count1 = 0;
	int count2 = 0;
	int count3 = 0;
	int cnt1 = 0; // ����
	int cnt2 = 0; // �ݴ�
	int cnt3 = 0; // ���
	int tot = 0;
	int tot2 = 0;
	p_bean = p_db.getPropBean(prop_id);
	
	//��۸���Ʈ
	PropCommentBean pc_r [] = p_db.getPropCommentList(prop_id);
	
	
	
	String reg_dt = Util.getDate();
	
	//��ϱ����� �������̸� ���Ϸ� �ؾ��Ѵ�.
	if(p_bean.getDay7().equals("20110508")){
		p_bean.setDay7("20110510");
	}
	
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
//�ǰߴޱ�
function RegComment(idx){
	var SUBWIN="./prop_comment_i.jsp<%=valus%>&prop_id=<%=prop_id%>&mode="+idx;
	window.open(SUBWIN, "CommentReg", "left=100, top=100, width=520, height=400, scrollbars=no");
}

//�����ϱ�
function UpDisp(idx){
	var fm = document.form1;
	var SUBWIN="./prop_u.jsp<%=valus%>&prop_id=<%=prop_id%>&mode="+idx+"&idx="+fm.idx.value;
	var height = 400;
	if(idx == 1) height = 700;
	window.open(SUBWIN, "AncUp", "left=100, top=100, width=900, height="+height+", scrollbars=no");
}

//���
function go_to_list()
{
	var fm = document.form1;
	fm.action = "./prop_t_frame.jsp";
	fm.target = 'd_content';
	fm.submit();
}	

function view_comment(prop_id, seq)
{
		window.open("prop_comment_u.jsp<%=valus%>&prop_id="+prop_id+"&seq="+seq, "MEMO", "left=100, top=100, width=720, height=500");
}

function view_c_eval(prop_id, seq)
{
		var auth_rw = document.form1.auth_rw.value;		
		var user_id = document.form1.user_id.value;		
		window.open("c_eval_frame_s.jsp?user_id="+user_id+"&prop_id="+prop_id+"&seq="+seq, "MEMO", "left=100, top=100, width=420, height=400");
}

function RegEvalAmt(prop_id){
	var user_id = document.form1.user_id.value;		
		
	var SUBWIN="./t_eval_frame_s.jsp?user_id="+user_id+"&prop_id="+prop_id;
	window.open(SUBWIN, "CommentReg", "left=100, top=100, width=520, height=400, scrollbars=no");
}

function RegCval(prop_id){
	var fm = document.form1;
	fm.action = "./prop_c_eval_i.jsp";
	fm.target = "i_no";
	fm.submit();
}

		//�˾������� ����
function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/prop/"+theURL;
		window.open(theURL,winName,features);
}
	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLp_db="javascript:self.focus()">

<form action="./prop_u2.jsp" name="form1" method="post">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='asc'	 	value='<%=asc%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>      
  <input type="hidden" name="prop_id" 	value="<%=prop_id%>">
  <input type="hidden" name="prize" 	value="<%=prize%>">
  <input type="hidden" name="mode" 		value="">
  <input type="hidden" name="idx" value="<%=idx%>">	
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>MASTER > <span class=style5>���Ȱ�� �󼼳���</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
	  <td align='right'>
		<a href="javascript:go_to_list()"><img src="/acar/images/center/button_list.gif"  align="absmiddle" border="0"></a>
	  </td>
	</tr>
	<tr>
		<td class=line2 ></td>
	</tr>
	<tr>
	  <td class="line">
		<table border="0" cellspacing="1" cellpadding="0" width=100%>			
		  <tr>
		  	<td width="5%" class="title">����</td>
			<td width="11%" align=center>&nbsp;<%=idx%></td>
			<td width="9%" class="title">�ۼ���</td>
			<td width="33%" align=center>&nbsp;
			<% if (  p_bean.getOpen_yn().equals("Y") || user_id.equals("000063")  ) { %><%=p_bean.getUser_nm()%>
			<% } else {  %>
			����� 
			<% } %></td>
			<td width="9%" class="title">�ۼ���</td>
			<td width="33%" align=center>&nbsp;<%=AddUtil.ChangeDate2(p_bean.getReg_dt())%></td>
		  </tr>
		</table>
	  </td>
	</tr>
	<tr>
		<td></td>
	</tr>
	
	<tr>	  
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ȳ���</span></td>    
	</tr>
	<tr>
		<td class=line2 ></td>
	</tr>
	<tr>	  
	  <td class=line>
	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
        <tr>
          <td colspan="2" class="title">&nbsp;<br><%if(p_bean.getUse_yn().equals("Y")){ %><img src=/images/mservice_icon.gif align=absmiddle><% } %>
          <%=p_bean.getTitle()%><br>&nbsp;</td>
        </tr>
        <tr>
          <td width=9% class="title">������</td>
          <td align="center"><table border="0" cellspacing="0" cellpadding="10" width=100%>
              <tr>
                <td><%=HtmlUtil.htmlBR(p_bean.getContent1())%></td>
              </tr>
          </table></td>
        </tr>
        <tr>
          <td class="title">������</td>
          <td align="center"><table border="0" cellspacing="0" cellpadding="10" width=100%>
              <tr>
                <td><%=HtmlUtil.htmlBR(p_bean.getContent2())%></td>
              </tr>
          </table></td>
        </tr>
        <tr>
          <td class="title">���ȿ��</td>
          <td align="center">
		    <table border="0" cellspacing="0" cellpadding="10" width=100%>
              <tr>
                <td><%=HtmlUtil.htmlBR(p_bean.getContent3())%></td>
              </tr>
            </table>
		  </td>
        </tr>
        <tr>
			<td class="title">÷������1</td>
			<td >&nbsp; <%if(!p_bean.getFile_name1().equals("")){%><a href="javascript:MM_openBrWindow('<%= p_bean.getFile_name1() %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><%= p_bean.getFile_name1() %></a><%}%></td>
		  </tr>
		  <tr>
			<td class="title">÷������2</td>
			<td >&nbsp; <%if(!p_bean.getFile_name2().equals("")){%><a href="javascript:MM_openBrWindow('<%= p_bean.getFile_name2() %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><%= p_bean.getFile_name2() %></a><%}%></td>
		  </tr>
		  <tr>
			<td class="title">÷������3</td>
		    <td >&nbsp; <%if(!p_bean.getFile_name3().equals("")){%><a href="javascript:MM_openBrWindow('<%= p_bean.getFile_name3() %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><%= p_bean.getFile_name3() %></a><%}%></td>
			</tr>
			
      </table></td>    
	</tr>
	<tr>
			<td colspan="2">��1��~15�� ���Ȱ��� ��� ��ϱⰣ�� ��� 22�ϱ��� ����� �� �ְ�, 16��~31�� ���Ȱ��� ��� ��ϱⰣ�� �Ϳ� 7�ϱ��� ����� �� �ֽ��ϴ�.<br>�ٸ�, ���Ƚɻ��Ͽ� ���� ����� �� �ֽ��ϴ�.</td>
		</tr>
	<tr>
		<td class=h ></td>
	</tr>
		
	<tr>	  
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���</span></td>    
	</tr>	
	<tr>
		<td class=line2 ></td>
	</tr>
	<tr>
	  <td class="line">
		<table border="0" cellspacing="1" cellpadding="0" width=100%>	
		  <tr>
		 	<td width="9%" class="title">ä�ÿ���</td>
			<td width="41%" >&nbsp;
			  <%if(p_bean.getUse_yn().equals("Y")){%>ä��
			  <%} else if(p_bean.getUse_yn().equals("M")){%>����ä��
			  <%} else if(p_bean.getUse_yn().equals("O")){%>��������ä��
			  <%} else if(p_bean.getUse_yn().equals("N")){%>��ä�� <% } %>
			</td>
			<td width="9%" class="title">ó������</td>
			<td width="41%">&nbsp;<%=AddUtil.ChangeDate2(p_bean.getAct_dt())%></td>				
		  </tr>
		  <tr>
		    <td class="title">����</td>
		    <td><%if(p_bean.getProp_step().equals("1")){%>
		        &nbsp;������
		        <%}%>
                <%if(p_bean.getProp_step().equals("2")){%>
                &nbsp;�ɻ���
                <%}%>
                <%if(p_bean.getProp_step().equals("3")){%>
                &nbsp;�����
                <%}%>
                <%if(p_bean.getProp_step().equals("5")){%>
                &nbsp;������
                <%}%>
                <%if(p_bean.getProp_step().equals("6")){%>
                &nbsp;ó����
                <%}%>             
                <%if(p_bean.getProp_step().equals("7")){%>
                &nbsp;�Ϸ�
                <%}%></td>
              <td class="title">�ɻ�����</td>
		      <td>&nbsp;<%=AddUtil.ChangeDate2(p_bean.getEval_dt())%></td>        
          </tr>      
          <tr>  
            <td class="title">�Ϸ�����</td>
		    <td>&nbsp;<%=AddUtil.ChangeDate2(p_bean.getExp_dt())%></td>
		    <td class="title">����ݾ�</td>
			<td >&nbsp;<%=Util.parseDecimal(p_bean.getPrize())%>&nbsp;
	      </tr>
		  <tr>		  
		    <td class="title">���ޱݾ�</td>
			<td >&nbsp;<%=Util.parseDecimal(p_bean.getJigub_amt())%>&nbsp;
		    </td>
		    <td class="title">��������</td>
		    <td>&nbsp;<%=AddUtil.ChangeDate2(p_bean.getJigub_dt())%></td>		
	      </tr>
	
		<tr>
			<td class="title" >�����ǰ�</td>
			
			<td colspan="3"><%=HtmlUtil.htmlBR(p_bean.getContent())%></td>

		</tr>
		</table>
	  </td>
	</tr>	
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
	  <td align='right'>
	   
		<% if (  user_id.equals("000063") || user_id.equals("000003") ) { %>
		<a href="javascript:UpDisp(2)" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif"  aligh="absmiddle" border="0"></a>
		<%	}%>
	
	  </td>
	</tr>		
	<tr>	  
	  <td>&nbsp;</td>    
	</tr>
  </table>
</form>	
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0"  noresize></iframe> 
</body>
</html>